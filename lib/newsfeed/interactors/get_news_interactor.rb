# frozen_string_literal: true

require 'dry-container'
require 'dry-monads'

module NewsFeed
  module Interactors
    class GetNewsContainer
      extend Dry::Container::Mixin
      extend Dry::Monads::Either::Mixin

      register :validate_input, ->(**input) {
        Right(input)
      }

      register :filter_output, ->(**input) {
        Right(input.fetch(:news))
      }
    end

    GetNewsInteractor =
      CreateInteractorHelper.from_transaction(private_container: GetNewsContainer) do
        step :validate_input
        step :get_next_news,
            with: 'collaborators.get_next_news_collaborator'
        step :filter_output
      end

  end
end
