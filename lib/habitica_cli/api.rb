require 'faraday'
require 'faraday_middleware'
require 'pry'

module HabiticaCli
  # responsible for communicating with habit at a low level
  class Api
    def initialize(user_id, api_token)
      @debug = ENV['DEBUG_HABITICA'] == 'true'

      @connection = create_connection(user_id, api_token)
    end

    def get(url)
      @connection.get(url)
    end

    def post(url, body)
      @connection.post(url, body)
    end

    def put(url, body)
      @connection.put(url, body)
    end

    private

    def default_headers(user_id, api_token)
      {
        'x-api-key' => api_token,
        'x-api-user' => user_id,
        'Content-Type' => 'application/json'
      }
    end

    def create_connection(user_id, api_token)
      Faraday.new(
        url: 'https://habitica.com/api/v2/',
        headers: default_headers(user_id, api_token)
      ) do |faraday|
        faraday.request :json

        faraday.response :json, content_type: /\bjson$/
        faraday.response :logger if @debug

        faraday.adapter  Faraday.default_adapter
      end
    end
  end
end
