require 'dry/transaction/operation'

module NewsFeed
  module Collaborators
    class PersistNewsCollaborator
      include NewsFeed.dependencies('repositories.news_repository')
      include Dry::Transaction::Operation
      include Log

      def call(news:, **input)
        news.each do |n|
          news_repository.save(n)
        end

        Right(news: news, **input)
      end

    end
  end
end
