# frozen_string_literal: true

require 'dry-container'
require 'dry-monads'

module NewsFeed
  module Interactors
    class FetchTranslateAndPersistNewsContainer
      extend Dry::Container::Mixin
      extend Dry::Monads::Either::Mixin

      register :validate_input, ->(**input) {
        Right(input)
      }

      register :filter_output, ->(**input) {
        Right(input.fetch(:news))
      }
    end

    FetchTranslateAndPersistNewsInteractor =
      CreateInteractorHelper.from_transaction(private_container: FetchTranslateAndPersistNewsContainer) do
        step :validate_input
        step :fetch_news,
            with: 'collaborators.fetch_news_collaborator'
        step :filter_existing_news,
            with: 'collaborators.filter_existing_news_collaborator'
        step :translate_news,
             with: 'collaborators.translate_news_collaborator'
        step :persist_news,
             with: 'collaborators.persist_news_collaborator'
        step :filter_output
      end

  end
end
