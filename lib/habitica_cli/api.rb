require "faraday"
require "faraday_middleware"
require "pry"

module HabiticaCli
  class Api
    def initialize(user_id, api_token)
      @debug = ENV['DEBUG_HABITICA'] == "true"

      @connection = create_connection(user_id, api_token)
    end

    def get(url)
      @connection.get(url)
    end

    private

    def create_connection(user_id, api_token)
      Faraday.new(
        :url => 'https://habitica.com/api/v2/',
        :headers => {
          'x-api-key' => api_token,
          'x-api-user' => user_id,
          'Content-Type' => 'application/json',
        }
      ) do |faraday|
        faraday.request :json

        faraday.response :json, :content_type => /\bjson$/
        faraday.response :logger if @debug

        faraday.adapter  Faraday.default_adapter
      end
    end
  end
end
