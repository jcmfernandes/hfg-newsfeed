require 'newsfeed/collaborators/fetch_news_collaborator'

RSpec.describe NewsFeed::Collaborators::FetchNewsCollaborator do

  let(:rss_sources) {
    %w{
      http://feeds.feedburner.com/PublicoRSS
    }
  }

  subject(:collaborator) {
    described_class.new(rss_sources: rss_sources)
  }

  describe '#call' do
    it "fetches items" do
      result = subject.call(rss_sources: rss_sources)

      expect(result.value).not_to be_empty
    end
  end
end
