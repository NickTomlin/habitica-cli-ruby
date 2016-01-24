module HabiticaCli
  # shared task related behavior
  class Task < Thor
    # TODO: consider using this inside display instead of select
    desc 'list <type>', 'list tasks, optionally filterd by <type>'
    method_option :show_completed, aliases: '-c', default: false, type: :boolean
    def list(type = nil)
      validate_type(type) if type
      response = api.get('user/tasks')

      if response.success?
        display(response, type)
      else
        puts 'Error connecting to habit api'
      end
    end

    desc 'add <text>', 'add a new habit'
    def add(type, text)
      validate_type(type)
      response = api.post('user/tasks', type: type, text: text)

      if response.success?
        puts "Added #{response.body['text']} #{response.body['id']}"
      else
        puts "Error adding #{text}: #{response.body}"
      end
    end

    desc 'do <id>', 'complete a todo, daily, or habit'
    def do(id)
      response = api.post("user/tasks/#{id}/up")

      if response.success?
        puts "Completed!"
      else
        puts "Error #{response.body}"
      end
    end

    desc 'clear', 'clear completed todos'
    def clear
      api.post('user/tasks/clear-completed')
    end

    private

    def validate_type(type)
      types = %w(todo habit daily)
      fail "Not a valid type (#{types})" unless types.include?(type)
    end

    def select(items, type = nil)
      items.select do |item|
        (type.nil? || item['type'] == type) &&
          (options['show_completed'] == true || item['completed'] != true)
      end
    end

    def display(response, type)
      items = select(response.body, type)
      puts type.capitalize unless type.nil?
      items.each do |item|
        output = type.nil? ? "#{item['type']} " : ''
        output += "- #{item['text']} #{item['id']}"
        puts output
      end
    end

    def api
      user = parent_options[:habit_user]
      key = parent_options[:habit_key]
      if user.empty? || key.empty?
        fail "You must provide a habit user and api key \n\n do this via (HABIT_USER and HABIT_KEY) or the --habit_user --habit_key" # rubocop:disable Metrics/LineLength
      end
      Api.new(user, key)
    end
  end
end
