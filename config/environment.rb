NewsFeed.configure do |config|
  config.logger.stdout_formatter = ENV['LOGGER_STDOUT_FORMATTER'] if ENV['LOGGER_STDOUT_FORMATTER']
  config.logger.level = ENV['LOGGER_LEVEL'] if ENV['LOGGER_LEVEL']
end
