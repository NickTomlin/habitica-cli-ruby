require 'thor'
require 'habitica_cli/api'
require 'habitica_cli/cache'

module HabiticaCli
  # At the moment this holds _all_ tasks
  # until we can figure out a better way to split
  # out top level tasks into individual files
  # (thor's DSL makes that a little bit of a chore at the moment)
  class Task < Thor
    class_option :habit_user, hide: true, default: ENV['HABIT_USER']
    class_option :habit_key, hide: true, default: ENV['HABIT_KEY']

    # TODO: consider using this inside display instead of select
    desc 'list <type>', 'list tasks, optionally filterd by <type>'
    method_option :show_completed, aliases: '-c', default: false, type: :boolean
    def list(type = nil)
      validate_type(type) if type
      response = api.get('user/tasks')

      if response.success?
        display(response.body, type)
      else
        puts 'Error connecting to habit api'
      end
    end

    desc 'status', 'Get user status, dailies'
    def status
      response = api.get('user')
      if response.success?
        stats = response.body['stats']
        puts [
          "Gold: #{stats['gp'].round}",
          "Health: #{stats['hp'].round}/#{stats['maxHealth']}"
        ].join(" | ")

        display(response.body['todos'] + response.body['dailys'], nil)
      else
        puts "Error: #{response.error}"
      end
    end

    desc 'add <habit | daily | todo> <text>', 'add a new task'
    def add(type, text)
      validate_type(type)
      response = api.post('user/tasks', type: type, text: text)

      if response.success?
        task = cache_tasks([response.body], type).first
        puts "Added #{task['text']} [#{task['cid']}]"
      else
        puts "Error adding #{text}: #{response.body}"
      end
    end

    desc 'do <id>', 'complete a todo, daily, or habit'
    def do(cache_id)
      item = cache.get(cache_id)
      response = api.post("user/tasks/#{item['id']}/up")

      if response.success?
        puts "Completed: #{item['text']}"
      else
        puts "Error #{response.body}"
      end
    end

    desc 'clear', 'clear completed todos'
    def clear
      api.post('user/tasks/clear-completed')
    end

    private

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

    def validate_type(type)
      types = %w(todo habit daily)
      fail "Not a valid type (#{types})" unless types.include?(type)
    end

    def filter_tasks(tasks, type = nil)
      tasks.select do |task|
        (type.nil? || task['type'] == type) &&
          (options['show_completed'] == true || task['completed'] != true)
      end
    end

    def select_attributes(tasks)
      keys = %w(completed id text type)
      tasks.map do |task|
        task.select { |k, _| keys.include?(k) }
      end
    end

    def cache_tasks(tasks, type)
      cache.store_tasks(
        select_attributes(filter_tasks(tasks, type))
      )
    end

    def display(raw_tasks, type)
      tasks = cache_tasks(raw_tasks, type)
      puts type.capitalize unless type.nil?
      tasks.each do |item|
        output = type.nil? ? "(#{item['type']}) " : ''
        output += "[#{item['cid']}] #{item['text']}"
        puts output
      end
    end
  end
end
