module HabiticaCli
  # Responsible for displaying a "dashboard" of stats
  # and tasks for a user as well as caching them
  module Commands
    def self.status(env)
      get_user_tasks(env)
      get_user_info(env)
    end

    def self.status_display(data)
      stats = data['stats']
      puts [
        "Gold: #{stats['gp'].round}",
        "Health: #{stats['hp'].round}/#{stats['maxHealth']}"
      ].join(' | ')
    end

    private_class_method

    def self.get_user_info(env)
      user_response = env.api.get('user')
      status_display(user_response.body['data'])
    end

    def self.get_user_tasks(env)
      task_response = env.api.get('tasks/user', type: 'dailys')
      display(env, task_response.body, nil)
    end
  end
end
