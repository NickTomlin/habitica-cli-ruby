module HabiticaCli
  # Handles basic configuration parsing
  # and interacts with Kefir for config storage
  class Config
    def initialize(cli_options)
      @options = cli_options
      @config = Kefir.config('habitica_cli')
    end

    def user_and_api_key
      config = Kefir.config('habitica_cli')
      habit_user, habit_key = @options.values_at(:habit_user, :habit_key)

      if blank?(habit_user) || blank?(habit_key)
        habit_user = config.get('habit_user')
        habit_key = config.get('habit_key')
      end

      [habit_user, habit_key]
    end

    def usage
      <<-ERR
**Error**: You must provide a habit user and api key
  Do this via:
  - adding `habit_user` and `habit_key` to #{@config.path}
  - setting HABIT_USER and HABIT_KEY in your shell
  - passing --habit_user --habit_key
ERR
    end

    private

    def blank?(obj)
      # rubocop:disable Style/DoubleNegation
      obj.respond_to?(:empty?) ? !!obj.empty? : !obj
      # rubocop:enable Style/DoubleNegation
    end
  end
end
