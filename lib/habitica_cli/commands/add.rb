module HabiticaCli
  # responsible for adding new todos, tasks, and dailies
  # also for for caching the newly added todo
  module Commands
    def self.add(env, type, text)
      validate_type(type)
      response = env.api.post('tasks/user', type: type, text: text)

      if response.success?
        task = cache_tasks(env, [response.body['data']], type).first
        puts "Added #{task['text']} [#{task['cid']}]"
      else
        puts "Error adding #{text}: #{response.body}"
      end
    end
  end
end
