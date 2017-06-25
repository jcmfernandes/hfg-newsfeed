require 'dry/transaction/operation'

module NewsFeed
  module Collaborators
    class GetNextNewsCollaborator
      include NewsFeed.dependencies('repositories.news_repository')
      include Dry::Transaction::Operation
      include Log

      def call(language:, url:, **input)
        news = if url.nil?
          news_repository.find_newest_by_language(language: language)
        else
          news_repository.find_next(url: url, language: language)
        end

        Right(news: news, **input)
      end

    end
  end
end
