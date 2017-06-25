# frozen_string_literal: true

require 'dry-configurable'

module NewsFeed
  class Configuration
    extend Dry::Configurable

    setting :logger do
      setting :stdout_formatter, 'human_readable'
      setting :level, 'info'
    end

    setting :supported_languages, ['ar', 'pt', 'en'].freeze
    setting :minimum_paragraph_size, 25

    setting :news_repository do
      setting :directory, 'resources/news'
    end

    setting :rss_sources, %w{
      http://feeds.feedburner.com/PublicoRSS
      http://feeds.feedburner.com/expresso-geral
    }

  end
end
