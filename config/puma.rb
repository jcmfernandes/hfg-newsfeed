#!/usr/bin/env puma

if ENV['APP_ROOT'] && ENV['APP_NAME']
  directory File.join(ENV['APP_ROOT'], ENV['APP_NAME'])
end

# default is 0,16 ! Please be careful about this
threads (ENV['HTTP_MIN_THREADS'] || 1).to_i, (ENV['HTTP_MAX_THREADS'] || 16).to_i

bind 'tcp://0.0.0.0:' + (ENV['PORT'] || 4567).to_s
