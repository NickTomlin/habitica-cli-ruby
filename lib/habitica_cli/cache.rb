require 'pstore'

module HabiticaCli
  # Extremely simplistic layer on top of PStore
  # Responsible for caching habit responses
  class Cache
    def initialize(path = nil)
      path = File.join(Dir.home, '.habitca-cli-cache') if path.nil?
      @store = PStore.new(path)
    end

    def get(key, default = nil)
      @store.transaction { @store.fetch(key, default) }
    end

    # rubocop:disable Metrics/MethodLength
    def store_tasks(items)
      shortened = nil
      count = get('count', 0)
      @store.transaction do
        shortened = items.map do |item|
          count += 1
          short_id = "#{item['id'][0]}#{count}"
          @store[short_id] = item
          short_id
        end
        @store[:count] = count
      end
      shortened
    end
    # rubocop:enable
  end
end
