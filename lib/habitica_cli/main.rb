module HabiticaCli
  # At the moment this holds _all_ tasks
  # until we can figure out a better way to split
  # out top level tasks into individual files
  # (thor's DSL makes that a little bit of a chore)
  class Main < Thor
    class_option :habit_user, hide: true, aliases: '--habit-user'
    class_option :habit_key, hide: true, aliases: '--habit-key'

    def initialize(*args)
      super(*args)
      @cache = cache
      @options = options
      @api = configure_api
    end

    # TODO: consider using this inside display instead of select
    desc 'list <type>', 'list tasks, optionally filterd by <type>'
    method_option :show_completed, aliases: '-c', default: false, type: :boolean
    def list(*args)
      Commands.list(env, *args)
    end

    desc 'status', 'Get user stats, dailies, and todos'
    def status
      Commands.status(env)
    end

    desc 'add <habit | daily | todo> <text>', 'add a new task'
    def add(type, text)
      Commands.add(env, type, text)
    end

    desc 'do <id> (<id> <id>)', 'complete a todo, daily, or habit. Pass multiple ids in separated by a space' # rubocop:disable Metrics/LineLength
    def do(*cache_ids)
      Commands.do(env, cache_ids)
    end

    desc 'clear', 'clear completed todos'
    def clear
      Commands.clear(env)
    end

    private

    def env
      OpenStruct.new(
        cache: @cache,
        api: @api,
        options: @options
      )
    end

    def configure_api
      config = Config.new(@options)
      user, key = config.user_and_api_key

      if user.nil? || key.nil?
        help
        puts config.usage
        exit 1
      end

      @api = Api.new(user, key)
    end

    def cache
      @cache ||= Cache.new
    end
  end
end
