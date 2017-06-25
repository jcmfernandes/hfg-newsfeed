require 'faraday'
require 'logstash-logger'

NewsFeed.setup do |s|
  s.register 'http_client', -> {
    Faraday.new do |conn|
      conn.adapter :excon, persistent: true
    end
  }

  s.register 'logger', -> {
    formatter =
      case NewsFeed.config.logger.stdout_formatter
      when 'human_readable'
        ::Logging::HumanReadableFormatter
      when 'json_lines'
        ::Logging::JsonLinesFormatter
      else
        ::Logging::HumanReadableFormatter
      end

    logger = LogStashLogger.new(type: :stdout, formatter: formatter)
    logger.level = NewsFeed.config.logger.level
    logger
  }, memoize: true

end
