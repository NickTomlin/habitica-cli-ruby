require 'habitica_cli/constants'

module HabiticaCli
  # shared task related behavior
  module Task
    private

    def type
      fail 'Not implemented'
    end

    def select(item)
      item['type'] == type
    end

    def display(response)
      items = response.body.select do |item|
        select(item)
      end

      puts type.capitalize
      puts '----'
      items.each do |item|
        puts "- #{item['text']} #{item['id']}\n"
      end
    end

    def _complete(id)
      response = api.post(
        "user/tasks/#{id}/up"
      )

      if response.success?
        puts "Completed #{response.body['text']}"
      else
        puts "Error #{response.body}"
      end
    end

    def _add(text)
      response = api.post(
        'user/tasks',
        type: type,
        text: text
      )

      if response.success?
        puts "Added #{response.body['text']}"
      else
        puts "Error adding #{text}: #{response.body}"
      end
    end

    def _list
      response = api.get('user/tasks')

      if response.success?
        display(response)
      else
        puts 'Error connecting to habit api'
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
