source 'https://rubygems.org'

ruby IO.read(File.join(__dir__, '.ruby-version')).strip

# Transport
gem 'puma', '~> 3.0'
gem 'sinatra'

# HTTP client (really, don't add your favorite one here, learn how to use faraday instead)
gem 'faraday', '~> 0.12.1'
gem 'excon', '~> 0.57.0'
gem 'typhoeus'

# Logging
gem 'logstash-logger', '~> 0.25.1'
gem 'liquid', '~> 4.0'

# Data serialization
gem 'oj', '~> 3.0'
gem 'multi_json', '~> 1.12', '>= 1.12.1'

# Feed extraction
gem 'fastimage', '~> 2.1'
gem 'ruby-readability', '~> 0.7.0'

# Concurrency
gem 'concurrent-ruby', '~> 1.0', '>= 1.0.2'

# Domain
gem 'dry-container', '< 0.7', '>= 0.6'
gem 'dry-auto_inject', '< 0.5', '>= 0.4.2'
gem 'dry-configurable', '< 0.8', '>= 0.7'
gem 'dry-equalizer', '< 0.3', '>= 0.2'
gem 'dry-transaction', '< 0.11', '>= 0.10.0'
gem 'dry-monads', '< 0.4', '>= 0.3.1'
gem 'dry-validation', '< 0.11', '>= 0.10.6'
gem 'dry-struct', '< 0.4', '>= 0.3'

# Hash utilities
gem 'hashie', '~> 3.5', '>= 3.5.5'
gem 'activesupport', '~> 5.0.0'

group :developement do
  gem 'pry'
  gem 'pry-doc'
  gem 'pry-byebug', platform: :ruby
  gem 'rubycritic', require: false
  gem 'guard', require: false
  gem 'guard-rspec', require: false
  gem 'rerun', require: :false
  gem 'gemsurance', require: false
  gem 'debride', require: false
end

group :test do
  gem 'rspec', '~> 3.5'
  gem 'rspec-given', '~> 3.8'
  gem 'mutant-rspec', '~> 0.8.0'
  gem 'rack-test', '~> 0.6', '>= 0.6.3'
  gem 'simplecov', require: false
  gem 'faker', '~> 1.6', '>= 1.6.3'
  gem 'timecop', '~> 0.9.0'
  gem 'as-duration', '~> 0.1.1'
end
