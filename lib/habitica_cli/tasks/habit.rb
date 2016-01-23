require 'habitica_cli/task'

module HabiticaCli
  # nodoc
  class Habit < Thor
    include HabiticaCli::Task

    desc 'list', 'list habits'
    def list
      _list
    end

    desc 'add <text>', 'add a new habit'
    def add(text)
      _add(text)
    end

    desc 'complete <id>', 'complete a habit'
    def complete(id)
      _complete(id)
    end

    private

    def type
      Types::Habit
    end
  end
end
