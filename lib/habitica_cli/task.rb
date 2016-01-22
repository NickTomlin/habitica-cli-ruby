module HabiticaCli
  module Task
    private

    def list_task_type(type)
      response = api.get('user/tasks')

      if response.success?
        display(response)
      else
        puts "Error connecting to habit api"
      end
    end

    def api
      Api.new(ENV['HABIT_USER'], ENV['HABIT_KEY'])
    end
  end
end
