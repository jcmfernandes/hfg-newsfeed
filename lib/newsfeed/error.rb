# frozen_string_literal: true

require 'securerandom'
require 'liquid'
require 'active_support/core_ext/hash/keys'

module NewsFeed
  class Error < ::StandardError

    attr_reader :context
    attr_reader :id
    attr_writer :wrapped_exception

    def self.create(title: nil)
      return Class.new(self) if title.nil?

      Class.new(self) do
        @@__title = title.dup.freeze
        def title
          @@__title
        end
      end
    end

    def initialize(detail = nil,
                   id: SecureRandom.uuid.freeze,
                   wrapped_exception: nil,
                   **context)
      @context = context.deep_stringify_keys.freeze

      @id = id
      @details = Array(detail)
      @wrapped_exception = wrapped_exception
    end

    def title
      @title ||= (title_from_code || 'Error')
    end

    def <<(msg)
      @details << msg
      self
    end

    def children
      result = []
      error = cause
      return result if error.nil?

      loop do
        result << error
        return result if error.cause.nil?
        error = error.cause
      end
    end

    def cause
      @wrapped_exception || super
    end

    def root_cause
      children.last
    end

    alias_method :wrapped_exception, :cause

    def details(include_children: true)
      result = @details.map do |detail|
        Liquid::Template.parse(detail).render(@context)
      end

      if include_children
        children_details = children.flat_map do |error|
          error.respond_to?(:details) ? error.details(include_children: false) : error.message
        end
        result.concat children_details
      end

      result
    end

    def detail(include_children: true)
      details(include_children: include_children).join("\n")
    end

    def code
      @code ||= self.class.name.split('::').last.freeze
    end

    alias_method :message, :detail
    alias_method :to_s, :detail

    def to_h
      {
        id: id,
        code: code,
        title: title,
        details: details,
        context: context,
      }
    end

    private

    def title_from_code
      words = code.scan(/[A-Z][a-z]+/.freeze)
      return if words.pop != 'Error' || words.empty?

      words.join(' ').freeze
    end

  end

  BadRequestError = Error.create
  ResourceNotFoundError = Error.create

  UnauthorizedRequestError = Error.create
  ServerError = Error.create(title: 'Server Error')
  TimeoutError = Error.create

end
