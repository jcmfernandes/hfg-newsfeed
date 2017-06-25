require 'newsfeed/gateways/http_rss_gateway'

RSpec.describe NewsFeed::Gateways::HttpRssGateway do

  subject(:gateway) {
    described_class.new
  }

  describe '#fetch_items' do
    it "fetches items" do
      url = 'http://feeds.feedburner.com/expresso-geral'

      result = subject.fetch_items(url: url)

      expect(result).not_to be_empty
    end
  end
end
