require 'dry/transaction/operation'
require 'newsfeed/entities/news'

module NewsFeed
  module Collaborators
    class TranslateNewsCollaborator
      include NewsFeed.dependencies('gateways.microsoft_translator_gateway',
                                    'config.supported_languages')
      include Dry::Transaction::Operation
      include Log

      def call(news:, **input)
        target_languages = supported_languages - ['pt']

        translations = news.flat_map do |n|
          target_languages.map do |target_language|
            title = microsoft_translator_gateway.translate(text: n.title, from: n.language, to: target_language)
            description = microsoft_translator_gateway.translate(text: n.description, from: n.language, to: target_language)
            content = microsoft_translator_gateway.translate(text: n.content, from: n.language, to: target_language)

            Entities::News.from_hash(n.to_h.merge(title: title, description: description, content: content, language: target_language))
          end
        end

        Right(news: news.concat(translations), **input)
      end

    end
  end
end
