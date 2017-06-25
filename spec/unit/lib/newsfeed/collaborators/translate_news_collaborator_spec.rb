require 'newsfeed/collaborators/translate_news_collaborator'

RSpec.describe NewsFeed::Collaborators::TranslateNewsCollaborator do

  subject(:collaborator) {
    described_class.new
  }

  describe '#call' do
    let(:news) {
      [
        NewsFeed::Entities::News.from_hash(
          language: 'pt',
          url: 'http://presidencia.pt',
          date: Time.now,
          images: [],
          title: 'Cavaco Silva encontrado morto dentro de uma pirâmide no Egito',
          description: 'Já se estava mesmo à espera deste desfecho.',
          content: '"Toda a gente sabe que este homem está morto há muitos anos." afirmou Simplício, um jovem pastor transmontano.'
        )
      ]
    }

    it "translates news" do
      result = subject.call(news: news)

      expect(result.value).not_to be_empty
    end
  end
end
