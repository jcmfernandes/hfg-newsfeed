# frozen_string_literal: true

require 'rack'
require 'rack/utils'

module Rack
  class RequestLoggerMiddleware

    FORMAT = %{"%s %s%s %s" %d %s %0.4f}

    def initialize(app, logger, severity = :info)
      @app = app
      @logger = logger
      @severity = severity
    end

    def call(env)
      began_at = Time.now
      status, header, body = @app.call(env)
      header = Rack::Utils::HeaderHash.new(header)

      log(env, status, header, began_at)

      [status, header, body]
    end

    private

    def log(env, status, header, began_at)
      now = Time.now
      length = extract_content_length(header)

      log_payload = {
        http_method: env[Rack::REQUEST_METHOD],
        path: env[Rack::PATH_INFO],
        query_string: env[Rack::QUERY_STRING].empty? ? '' : "?#{env[Rack::QUERY_STRING]}",
        http_version: env[Rack::HTTP_VERSION],
        status: status.to_s[0..3].to_i,
        length: length,
        service: now - began_at,
      }
      # The line below is dependent on the order in which keys
      # were declared in log_payload. Be careful!
      log_payload[:message] = FORMAT % log_payload.values

      @logger.public_send @severity, log_payload
    end

    def extract_content_length(headers)
      value = headers[Rack::CONTENT_LENGTH] or return '-'
      value.to_s == '0' ? '-' : value
    end
  end
end
