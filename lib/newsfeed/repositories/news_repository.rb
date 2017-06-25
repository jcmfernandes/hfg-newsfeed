module NewsFeed
  module Repositories
    class NewsRepository
      include NewsFeed.dependencies('config.news_repository.directory',
                                    'config.supported_languages')

    def initialize(*)
      super

      reload_datastore!
    end

    def save(news)
      id = id_from_url(news.url)
      datastore.fetch(news.language) << news
      datastore.fetch(news.language).sort! { |a, b| b.date <=> a.date }
      IO.write(news_path(language: news.language, id: id), news.to_json)
      news
    end

    def find_by_url_and_language(url:, language:)
      datastore.fetch(language).find { |n| n.url == url }
    end

    def find_next(url:, language:)
      all_for_language = find_by_language(language: language)
      index = all_for_language.find_index { |n| n.url == url }
      return if index.nil? || index + 1 == all_for_language.size
      all_for_language[index + 1]
    end

    def find_by_language(language:)
      datastore.fetch(language)
    end

    def find_newest_by_language(language:)
      find_by_language(language: language).first
    end

    private

    def datastore
      @datastore ||= {}
    end

    def reload_datastore!
      supported_languages.each do |language|
        FileUtils.mkdir_p(news_path(language: language, id: ''))
        datastore[language] = []
        Dir.glob(File.join(news_path(language: language, id: ''), '*')).each do |file|
          datastore[language] << Entities::News.from_hash(JSON.parse(IO.read(file), symbolize_names: true))
          datastore[language].sort! { |a, b| b.date <=> a.date }
        end
      end

      true
    end

    def news_path(id:, language:)
      File.join(directory, language, id)
    end

    def id_from_url(url)
      Digest::SHA256.hexdigest url
    end

    end
  end
end
