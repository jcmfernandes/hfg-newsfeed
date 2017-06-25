# frozen_string_literal: true

require 'securerandom'

module Rack
  class FillLoggerContextMiddleware

    def initialize(app, logger_context)
      @app = app
      @logger_context = logger_context
    end

    def call(env)
      request_id = env['HTTP_X_REQUEST_ID'] || SecureRandom.uuid.freeze

      @logger_context['request_id'] = request_id
      @logger_context['platform_tid'] = env['HTTP_X_PLATFORM_TID'] || request_id
      @logger_context['client_ip'] = env['HTTP_X_FORWARDED_FOR'] || env['REMOTE_ADDR']

      @app.call(env)
    ensure
      @logger_context.clear
    end
  end
end
