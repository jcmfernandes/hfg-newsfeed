require 'dry/transaction/operation'

module NewsFeed
  module Collaborators
    class FilterExistingNewsCollaborator
      include NewsFeed.dependencies('repositories.news_repository')
      include Dry::Transaction::Operation
      include Log

      def call(news:, **input)
        filtered_news = news.reject do |n|
          news_repository.find_by_url_and_language(url: n.url, language: n.language)
        end

        Right(news: filtered_news, **input)
      end

    end
  end
end
