# frozen_string_literal: true

ENV['RACK_ENV'] ||= 'none'
ENV['APP_ENV']  ||= 'development'

$LOAD_PATH << File.join(__dir__, 'lib')
$LOAD_PATH << File.join(__dir__, 'app', 'http')

require_relative 'config/boot'

require 'rack/fill_logger_context_middleware'
use Rack::FillLoggerContextMiddleware, NewsFeed.logger_context

require 'rack/request_logger_middleware'
use Rack::RequestLoggerMiddleware, NewsFeed.logger

require 'app'
run Sinatra::Application
