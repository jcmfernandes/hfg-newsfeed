require 'rss'
require 'open-uri'

module NewsFeed
  module Gateways
    class HttpRssGateway

      class Item

        attr_reader :link, :title, :description, :date

        def initialize(link:, title:, description:, date:, category:)
          @link = link
          @title = title
          @description = description
          @date = date
          @category = category
        end

        def to_h
          {
            link: link,
            title: title,
            description: description,
            date: date,
          }
        end
      end

      def fetch_items(url:)
        rss = RSS::Parser.parse(open(url).read)
        rss.items.map do |item|
          Item.new(link: item.link,
                   title: item.title,
                   description: item.description,
                   date: item.date,
                   category: item.category)
        end
      end

    end
  end
end
