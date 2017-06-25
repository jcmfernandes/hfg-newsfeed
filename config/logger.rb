# frozen_string_literal: true

require 'logstash-logger'
require 'liquid'
require 'multi_json'
require 'concurrent'

module Logging

  LOGGER_CONTEXT = Concurrent::ThreadLocalVar.new(Hash.new)

  module RFC5424
    SEVERITIES_MAPPING = {
      'DEBUG' => 'debug',
      'INFO' => 'info',
      'NOTICE' => 'notice',
      'WARN' => 'warning',
      'ERROR' => 'err',
      'FATAL' => 'crit',
    }.freeze

    def self.convert_severity(severity)
      SEVERITIES_MAPPING[severity] || severity.downcase
    end
  end

  class JsonLinesFormatter < LogStashLogger::Formatter::Base

    def call(severity, time, progname, message)
      super(RFC5424.convert_severity(severity), time, progname, message)
      @event.type = 'json'
      @event['source'] = progname
      @event['message'] = Liquid::Template.parse(@event['message']).render(LOGGER_CONTEXT.value)

      "#{MultiJson.dump(@event)}\n"
    end
  end

  class HumanReadableFormatter < LogStashLogger::Formatter::Base

    private

    DEFAULT_KEYS = [
      'platform_tid',
      'request_id',
      'thread_id',
      'client_ip',
      'severity',
    ].freeze

    public

    def call(severity, time, progname, message)
      super(RFC5424.convert_severity(severity), time, progname, message)
      passed_key_values = format_hash(message, message.keys - ['message', :message]) if message.is_a?(Hash)
      default_key_values = format_hash(@event.to_hash, DEFAULT_KEYS)
      message = Liquid::Template.parse(@event['message']).render(LOGGER_CONTEXT.value)

      "#{time.utc.iso8601(3)} #{@event['host']} #{progname || app_name}" \
        " [#{[default_key_values, passed_key_values].compact.join(' ')}]" \
        " #{message}\n"
    end

    private

    def format_hash(hash, keys = nil)
      kvs = (keys || hash.keys).map do |k|
        "#{k}=\"#{hash[k]}\"" if hash.has_key?(k)
      end
      str = kvs.tap(&:compact!).join(' ')
      str.empty? ? nil : str
    end
  end

  BASE_REQUEST_INFORMATION = {
    'platform_tid' => -> { LOGGER_CONTEXT.value['platform_tid'] },
    'request_id' => -> { LOGGER_CONTEXT.value['request_id'] },
    'thread_id' => -> { Thread.current.object_id.to_s },
    'client_ip' => -> { LOGGER_CONTEXT.value['client_ip'] },
  }.freeze

  LogStashLogger.configure do |config|
    config.max_message_size = 2000
    config.customize_event do |event|
      BASE_REQUEST_INFORMATION.each do |k, v|
        event[k] = v.call
      end
      event.fields.merge!(LOGGER_CONTEXT.value)
      event[:app_env] = app_env
      event[:production_env?] = production_env?
    end
  end
end
