module HabiticaCli
  # responsible for communicating with habit at a low level
  class Api
    # A simple wrapper for API errors
    class ApiError < StandardError
      def initialize(response)
        @response = response
        set_backtrace([])
      end

      def to_s
        errors = @response.body['errors'] || []
        path = @response.url.path
        error_messages = errors.map { |e| e['message'] }
        %(
Habitica Error (#{path}): #{@response.body['message']}
====
#{error_messages.join("\n")}
)
      end
    end

    # generic handling for habitica responses
    class HabiticaResponseMiddleware < Faraday::Middleware
      def call(request_env)
        @app.call(request_env).on_complete do |response_env|
          fail ApiError.new(response_env) unless response_env.success? # rubocop:disable Style/RaiseArgs, Metrics/LineLength
          response_env
        end
      end
    end

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

      faraday.use HabiticaResponseMiddleware
      faraday.response :json, content_type: /\bjson$/
      faraday.response :logger if @debug

      faraday.adapter Faraday.default_adapter
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
