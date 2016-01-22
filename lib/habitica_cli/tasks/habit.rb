require 'habitica_cli/task'

module HabiticaCli
  # nodoc
  class Habit < Thor
    include HabiticaCli::Task

    desc 'list', 'list habits'
    def list
      list_task_type('habit')
    end

    private

    def display(response)
      habits = response.body.select do |task|
        task['type'] == 'habit'
      end

      habits.each do |item|
        puts "- #{item['text']}\n"
      end
    end
  end
end
