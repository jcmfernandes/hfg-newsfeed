require 'sinatra'
require 'securerandom'
require 'concurrent'
require 'newsfeed'
require 'multi_json'

$stdout.sync = true

post '/article' do
  request_body = request.body.read
  request = MultiJson.load(request_body, symbolize_keys: true)

  id = extract_id(request)
  language, location = extract_configuration(request)

  puts "Requested for: id #{id}, language: #{language}, location: #{location}"

  state = InteractionState.for(id: id, language: language, location: location)

  article = state.next_article
  data = article.to_h.merge(summary: article.description)
  data.delete(:description)

  content_type 'application/json'
  MultiJson.dump(data)
end

post '/refresh' do
  new_articles = NewsFeed.invoke('interactors.fetch_translate_and_persist_news_interactor', bla: []).value

  content_type 'application/json'
  MultiJson.dump(new_articles: new_articles.size)
end

def extract_configuration(request)
  [extract_language(request), extract_location(request)]
end

def extract_language(request, fallback_language: 'language-pt')
  safely_do(fallback: fallback_language) {
    request
      .values
      .find { |entry| entry.is_a?(Hash) && entry[:__flowxo_task_name__] == 'Ask for Language' }[:parsed_answer]
  }
end

def extract_location(request, fallback_location: 'location-pt')
  safely_do(fallback: fallback_location) {
    request
      .values
      .find { |entry| entry.is_a?(Hash) && entry[:__flowxo_task_name__].include?('Ask for Location') }[:parsed_answer]
  }
end

def extract_id(request)
  safely_do(fallback: SecureRandom.uuid) {
    request.values.find { |entry| entry.is_a?(Hash) && entry[:channel_id] }[:channel_id]
  }
end

def safely_do(fallback:)
  yield || fallback
rescue => e
  puts "Error #{e.class} #{e.message} #{e.backtrace.join("\n")}"
  fallback
end

class InteractionState
  ALL_STATES = Concurrent::Map.new

  def self.for(id:, language:, location:)
    ALL_STATES[id] ||= InteractionState.new(id: id, language: language, location: location)
  end

  attr_reader :id, :language, :location
  attr_accessor :current_article

  def initialize(id:, language:, location:)
    @id = id
    @language = language[-2..-1]
    @location = location
    puts "Created new interaction state: id: #{id}, language: #{language}, location: #{location}"
  end

  def next_article
    new_article = NewsFeed.invoke('interactors.get_news_interactor', url: current_article&.url, language: language).value

    self.current_article = new_article

    puts "Returning article with URL #{new_article.url}"

    new_article
  end
end
