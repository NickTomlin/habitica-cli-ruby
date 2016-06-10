module HabiticaCli
  # Responsible for listing tasks
  module Commands
    def self.list(env, type = nil)
      validate_type(type) if type
      response = env.api.get('tasks/user')

      if response.success?
        display(env, response.body, type)
      else
        puts 'Error connecting to habit api'
      end
    end
  end
end
