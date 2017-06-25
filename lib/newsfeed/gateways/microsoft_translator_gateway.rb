require 'typhoeus'

module NewsFeed
  module Gateways
    class MicrosoftTranslatorGateway

      def translate(text:, from:, to:)
        auth_request = Typhoeus::Request.new(
          "https://api.cognitive.microsoft.com/sts/v1.0/issueToken",
          method: :post,
          headers: {
            'Content-type' => 'application/json',
            'Accept' => 'application/jwt',
            'Ocp-Apim-Subscription-Key' => '6832dacb14be4c3ea1bfda6c2a5a10f1'
          },
        )

        access_token = auth_request.run.response_body

        translation_request = Typhoeus::Request.new(
          "https://api.microsofttranslator.com/v2/http.svc/Translate",
          method: :get,
          headers: {'Accept' => 'application/xml'},
          params: {
            appid: "Bearer #{access_token}",
            text: text,
            from: from,
            to: to,
          }
        )

        translation = translation_request.run.response_body

        translation.split('>').last.split('<').first
      end

    end
  end
end

# MicrosoftTranslator.call(text: 'Olá', from: 'pt', to: 'ar')
