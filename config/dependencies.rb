# frozen_string_literal: true

require 'newsfeed/gateways/http_rss_gateway'
require 'newsfeed/gateways/microsoft_translator_gateway'

require 'newsfeed/collaborators/fetch_news_collaborator'
require 'newsfeed/collaborators/filter_existing_news_collaborator'
require 'newsfeed/collaborators/translate_news_collaborator'
require 'newsfeed/collaborators/persist_news_collaborator'
require 'newsfeed/collaborators/get_next_news_collaborator'

require 'newsfeed/repositories/news_repository'

require 'newsfeed/interactors/fetch_translate_and_persist_news_interactor'
require 'newsfeed/interactors/get_news_interactor'

module NewsFeed
  NewsFeed.setup do |s|
    s.register 'gateways.http_rss_gateway', -> { Gateways::HttpRssGateway.new }, memoize: true
    s.register 'gateways.microsoft_translator_gateway', -> { Gateways::MicrosoftTranslatorGateway.new }, memoize: true

    s.register 'collaborators.fetch_news_collaborator', -> { Collaborators::FetchNewsCollaborator.new }, memoize: true
    s.register 'collaborators.filter_existing_news_collaborator', -> { Collaborators::FilterExistingNewsCollaborator.new }, memoize: true
    s.register 'collaborators.translate_news_collaborator', -> { Collaborators::TranslateNewsCollaborator.new }, memoize: true
    s.register 'collaborators.persist_news_collaborator', -> { Collaborators::PersistNewsCollaborator.new }, memoize: true
    s.register 'collaborators.get_next_news_collaborator', -> { Collaborators::GetNextNewsCollaborator.new }, memoize: true

    s.register 'repositories.news_repository', -> { Repositories::NewsRepository.new }, memoize: true

    s.register 'interactors.fetch_translate_and_persist_news_interactor', -> { Interactors::FetchTranslateAndPersistNewsInteractor.new }, memoize: true
    s.register 'interactors.get_news_interactor', -> { Interactors::GetNewsInteractor.new }, memoize: true
  end
end
