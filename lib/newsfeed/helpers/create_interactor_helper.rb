require 'dry-transaction'
require 'dry-container'

module NewsFeed
  module CreateInteractorHelper

    def self.from_transaction(private_container: nil, &block)
      container = Dry::Container.new
      container.merge(private_container) unless private_container.nil?

      klass = Class.new(::SimpleDelegator) do

        def initialize(container: NewsFeed.system, **kwargs)
          klass = Class.new
          klass.send :include, Dry::Transaction(container: self.class.const_get(:BASE_CONTAINER, false).merge(container))
          klass.class_exec(&self.class.const_get(:TRANSACTION_BLOCK, false))

          super klass.new(**kwargs)
        end

        def call(*args, &block)
          super(*args, &block)
        rescue Error
          raise
        rescue
          raise Error
        end
      end

      klass.const_set(:BASE_CONTAINER, container)
      klass.const_set(:TRANSACTION_BLOCK, block)

      klass
    end

  end
end
