require 'thread'

module NewsFeed
  module Log

    MUTEX = Mutex.new

    def logger
      MUTEX.synchronize do
        @logger ||= NewsFeed.system['logger'.freeze]
      end
    end

    def logger_context
      ::Logging::LOGGER_CONTEXT.value
    end

  end
end
