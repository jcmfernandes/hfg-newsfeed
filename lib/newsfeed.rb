# frozen_string_literal: true

require 'newsfeed/env'
require 'newsfeed/system_setup'
require 'newsfeed/configuration'
require 'newsfeed/log'
require 'newsfeed/error'

module NewsFeed
  def self.config
    Configuration.config
  end

  extend SystemSetup
  extend Log

  Dir.glob(File.join(__dir__, 'newsfeed', 'helpers', '*.rb')).each do |file|
    load file
  end

  def self.enable_instrumentation!
    system.each do |dependency_name, obj|
      methods =
        if dependency_name.start_with?('interactors')
          [:call]
        elsif dependency_name.start_with?('gateways')
          obj.public_methods(false)
        end

      Instrumentation::StatsD.instrument_methods(obj: obj,
                                                 methods: methods,
                                                 dependency_name: dependency_name)
    end

    true
  end

end
