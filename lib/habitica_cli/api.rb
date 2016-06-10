module HabiticaCli
  # responsible for communicating with habit at a low level
  class Api
    def initialize(user_id, api_token)
      @debug = ENV['DEBUG_HABITICA'] == 'true'
      @user_id = user_id
      @api_token = api_token
    end

    def get(url, query = nil)
      connection do |faraday|
        faraday.request :url_encoded
      end.get(url, query)
    end

    def post(url, body = nil)
      connection.post(url, body)
    end

    def put(url, body)
      connection.put(url, body)
    end

    private

    def default_headers(user_id, api_token)
      {
        'x-api-key' => api_token,
        'x-api-user' => user_id,
        'Content-Type' => 'application/json'
      }
    end

    def configure_defaults(faraday)
      faraday.request :json

      faraday.response :json, content_type: /\bjson$/
      faraday.response :logger if @debug

      faraday.adapter  Faraday.default_adapter
    end

    def connection
      Faraday.new(
        url: 'https://habitica.com/api/v3/',
        headers: default_headers(@user_id, @api_token)
      ) do |faraday|
        configure_defaults(faraday)
        yield faraday if block_given?
        faraday
      end
    end
  end
end
