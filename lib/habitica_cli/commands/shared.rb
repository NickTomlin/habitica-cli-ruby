module HabiticaCli
  # Functionality common to all commands
  module Commands
    def self.validate_type(type)
      types = %w(todo habit daily)
      fail "Not a valid type (#{types})" unless types.include?(type)
    end

    def self.filter_tasks(env, tasks, type = nil)
      tasks.select do |task|
        (type.nil? || task['type'] == type) &&
          (env.options['show_completed'] == true || task['completed'] != true)
      end
    end

    def self.select_attributes(tasks)
      keys = %w(completed id text type)
      tasks.map do |task|
        task.select { |k, _| keys.include?(k) }
      end
    end

    def self.cache_tasks(env, tasks, type)
      env.cache.store_tasks(
        select_attributes(filter_tasks(env, tasks, type))
      )
    end

    def self.display(env, body, type)
      raw_tasks = body['data']
      tasks = cache_tasks(env, raw_tasks, type)
      puts type.capitalize unless type.nil?
      tasks.each do |item|
        output = type.nil? ? "(#{item['type']}) " : ''
        output += "[#{item['cid']}] #{item['text']}"
        puts output
      end
    end
  end
end
