module HabiticaCli
  # Responsible for displaying a "dashboard" of stats
  # and tasks for a user as well as caching them
  module Commands
    def self.status(env)
      response = env.api.get('user')
      if response.success?
        puts status_display(response.body)
        display(env, response.body['todos'] + response.body['dailys'], nil)
      else
        puts "Error: #{response.error}"
      end
    end

    def self.status_display(body)
      stats = body['stats']
      puts [
        "Gold: #{stats['gp'].round}",
        "Health: #{stats['hp'].round}/#{stats['maxHealth']}"
      ].join(' | ')
    end
  end
end
