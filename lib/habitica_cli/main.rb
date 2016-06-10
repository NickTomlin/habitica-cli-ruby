require 'ostruct'

module HabiticaCli
  # At the moment this holds _all_ tasks
  # until we can figure out a better way to split
  # out top level tasks into individual files
  # (thor's DSL makes that a little bit of a chore at the moment)
  class Main < Thor
    class_option :habit_user, hide: true, default: ENV['HABIT_USER']
    class_option :habit_key, hide: true, default: ENV['HABIT_KEY']

    def initialize(*args)
      super(*args)
      @api = api
      @cache = cache
      @options = options
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

    def cache
      @cache ||= Cache.new
    end

    def api
      user = options[:habit_user]
      key = options[:habit_key]
      if user.empty? || key.empty?
        fail "You must provide a habit user and api key \n\n do this via (HABIT_USER and HABIT_KEY) or the --habit_user --habit_key" # rubocop:disable Metrics/LineLength
      end
      Api.new(user, key)
    end
  end
end
