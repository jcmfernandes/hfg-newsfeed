require 'newsfeed/env'

require 'pry' if development_env? || test_env?

require_relative 'logger'

require 'newsfeed'

require_relative 'environment'
require_relative 'connections'
require_relative 'dependencies'

NewsFeed.logger.progname = app_name
$LOGGER = $LOG = NewsFeed.logger

Dir.glob(File.join(__dir__, 'initializers', '*.rb')).each do |file|
  load file
end
