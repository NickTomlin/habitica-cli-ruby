module HabiticaCli
  # shared task related behavior
  module Task
    private

    def list_task_type(_type)
      response = api.get('user/tasks')

      if response.success?
        display(response)
      else
        puts 'Error connecting to habit api'
      end
    end

    def api
      user = parent_options['habit_user']
      key = parent_options['habit_key']
      if user.empty? || key.empty?
        raise "You must provide a habit user and api key \n\n do this via (HABIT_USER and HABIT_KEY) or the --habit_user --habit_key"
      end
      Api.new(user, key)
    end
  end
end
