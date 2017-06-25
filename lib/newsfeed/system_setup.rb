require 'dry-container'
require 'dry/container/stub'
require 'dry-auto_inject'

module NewsFeed
  module SystemSetup

    def self.extended(mod)
      mod.instance_eval(%Q{
        def self.config
          raise "must implement #{mod.name}.config method"
        end
      }) unless mod.respond_to?(:config)
    end

    def configure
      yield config
      configuration_container = create_container_from_hash(config.to_h)
      system.merge(configuration_container, namespace: 'config'.freeze)
      self
    end

    def system
      @container ||= Dry::Container.new
    end

    def setup
      yield system
      self
    end

    def invoke(name, *args, &block)
      system.resolve(name).call(*args, &block)
    end

    def dependencies(*names)
      @injector ||= Dry::AutoInject(system).hash
      @injector[*names]
    end

    def enable_stubs!
      system.enable_stubs!
    end

    private

    def create_container_from_hash(hash, container = Dry::Container.new, key_name = [])
      hash.each do |k, v|
        if v.is_a?(Hash)
          create_container_from_hash(v, container, key_name + [k])
        else
          container.register((key_name + [k]).join('.'), v)
        end
      end
      container
    end

  end
end
