require 'time'
require 'dry-equalizer'
require 'multi_json'

module NewsFeed
  module Entities
    class News

      attr_reader :url, :language, :title, :description, :content, :date, :images

      def self.from_hash(**hash)
        self.new(**hash)
      end

      def initialize(url:, language:, title:, description:, content:, date:, images:)
        @url = url
        @language = language
        @title = title
        @description = description
        @content = content
        @date =
          if date.is_a?(::Time)
            date
          else
            Time.parse(date)
          end
        @images = images
      end

      def to_h
        {
          url: url,
          language: language,
          title: title,
          description: description,
          content: content,
          date: date,
          images: images,
        }
      end

      def to_json
        MultiJson.dump(to_h)
      end

      include Dry::Equalizer(:url, :language, :title, :description, :content, :date, :images)

    end
  end
end
