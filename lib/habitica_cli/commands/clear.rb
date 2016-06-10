module HabiticaCli
  # Clear completed tasks
  # to slim down output
  module Commands
    def self.clear(env)
      env.api.post('tasks/clear-completed')
      if response.success?
        puts 'Tasks cleared'
      else
        puts "Error #{response.body}"
      end
    end
  end
end
