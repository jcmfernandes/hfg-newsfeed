ENV['RACK_ENV'] = 'none'.freeze
ENV['APP_ENV']  = 'test'.freeze

require 'pry'
require 'faker'

$LOAD_PATH << File.join(__dir__, '..', 'lib')
$LOAD_PATH << File.join(__dir__, '..', 'app', 'http')

if ENV['COVERAGE'] == '1'
  require 'simplecov'
  SimpleCov.start do
    add_filter "/spec/"
    add_filter "/config/"
    add_filter do |source_file|
      source_file.lines.count < 5
    end
    coverage_dir 'tmp/coverage'
  end
end

# The `.rspec` file also contains a few flags that are not defaults but that
# users commonly want.
#
# See http://rubydoc.info/gems/rspec-core/RSpec/Core/Configuration
RSpec.configure do |config|
  require 'rack/test'
  config.include Rack::Test::Methods

  config.expect_with :rspec do |expectations|
    expectations.include_chain_clauses_in_custom_matcher_descriptions = true
  end

  config.mock_with :rspec do |mocks|
    mocks.verify_partial_doubles = true
    mocks.verify_doubled_constant_names = true
  end

  config.shared_context_metadata_behavior = :apply_to_host_groups

  config.filter_run_when_matching :focus
  config.filter_run_excluding broken: true

  config.example_status_persistence_file_path = 'spec/examples.txt'

  config.disable_monkey_patching!

  config.warnings = true

  if config.files_to_run.one?
    config.default_formatter = 'doc'
  end

  config.profile_examples = 5

  config.order = :random

  Kernel.srand config.seed

  require 'rspec/given'
end

require_relative '../config/boot'
NewsFeed.enable_stubs!

require 'logstash-logger'
NewsFeed.system.stub('logger', LogStashLogger.new(type: :file, path: '/dev/null'))
