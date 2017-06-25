require 'readability'
require 'nokogiri'
require 'open-uri'
require 'dry/transaction/operation'
require 'newsfeed/entities/news'

module NewsFeed
  module Collaborators
    class FetchNewsCollaborator
      include NewsFeed.dependencies('gateways.http_rss_gateway',
                                    'config.rss_sources',
                                    'config.minimum_paragraph_size')
      include Dry::Transaction::Operation
      include Log

      def call(**input)
        rss_items = rss_sources.flat_map do |rss_source|
          http_rss_gateway.fetch_items(url: rss_source)
        end

        news = rss_items.map do |rss_item|
          html_website = open(rss_item.link).read
          html_content = Readability::Document.new(html_website).content

          content = Nokogiri::HTML(html_content).xpath('//p/text()').map do |paragraph|
            paragraph.text.strip
          end
          content.reject { |paragraph| paragraph.size < minimum_paragraph_size }
          content = content.join("\n")

          data = {
            url: rss_item.link,
            language: 'pt',
            title: Nokogiri::HTML.parse(rss_item.title).text,
            description: Nokogiri::HTML.parse(rss_item.description).text,
            content: content,
            date: rss_item.date,
            images: [],
          }
          Entities::News.from_hash(data)
        end

        Right(news: news, **input)
      end

    end
  end
end
