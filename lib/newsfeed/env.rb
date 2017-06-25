require 'concurrent'

CURRENT_ENVIRONMENT = Concurrent::ThreadLocalVar.new((ENV['APP_ENV'].dup || 'development').freeze)

def app_name
  (ENV['APP_NAME'].dup || 'newsfeed').freeze
end

def app_env
  CURRENT_ENVIRONMENT.value
end

def production_env?
  app_env == 'production'.freeze
end

def staging_env?
  app_env == 'staging'.freeze
end

def development_env?
  app_env == 'development'.freeze
end

def test_env?
  app_env == 'test'.freeze
end

def set_env(env)
  return unless block_given?

  CURRENT_ENVIRONMENT.bind(env.to_s.dup.freeze) { yield }
end
