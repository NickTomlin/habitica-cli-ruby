module HabiticaCli
  # Responsible for displaying a "dashboard" of stats
  # and tasks for a user as well as caching them
  module Commands
    class ApiError < StandardError
      def initialize(response)
        @response = response
      end
    end

    def self.status(env)
      begin
        get_user_tasks(env)
        get_user_info(env)
      rescue ApiError => e
        handle_error(e.response)
      end
    end

    def self.status_display(data)
      stats = data['stats']
      puts [
        "Gold: #{stats['gp'].round}",
        "Health: #{stats['hp'].round}/#{stats['maxHealth']}"
      ].join(' | ')
    end

    private

    def self.handle_error(response)
      puts "Error: #{response.error}"
    end

    def self.get_user_info(env)
      user_response = env.api.get('user')
      raise ApiError(user_response) unless user_response.success?
      status_display(user_response.body['data'])
    end

    def self.get_user_tasks(env)
      task_response = env.api.get('tasks/user', type: 'dailys')
      raise ApiError(task_response) unless task_response.success?
      display(env, task_response.body, nil)
    end
  end
end
