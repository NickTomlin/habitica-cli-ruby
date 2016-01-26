module HabiticaCli
  # Responsible for completing tasks
  module Commands
    def self.do(env, cache_ids)
      items = cache_ids.map { |id| env.cache.get(id) }
      items.each do |item|
        response = env.api.post("user/tasks/#{item['id']}/up")
        if response.success?
          puts "Completed: #{item['text']}"
        else
          puts "Error #{response.body}"
        end
      end
    end
  end
end
