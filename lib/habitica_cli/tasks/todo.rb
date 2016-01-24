require 'habitica_cli/task'

module HabiticaCli
  # nodoc
  class Todo < Thor
    include HabiticaCli::Task

    desc 'list', 'list todos'
    def list
      _list
    end

    desc 'add <text>', 'add a new todo'
    def add(text)
      _add(text)
    end

    desc 'complete <id>', 'complete a todo'
    def complete(id)
      _complete(id)
    end

    private

    def type
      Types::TODO
    end

    def select(item)
      super(item) && item['completed'] != true
    end
  end
end
