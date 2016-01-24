require 'habitica_cli/task'

module HabiticaCli
  # nodoc
  class Daily < Thor
    include HabiticaCli::Task

    desc 'list', 'list dailies'
    def list
      _list
    end

    desc 'add <text>', 'add a new daily'
    def add(text)
      _add(text)
    end

    desc 'complete <id>', 'complete a daily'
    def complete(id)
      _complete(id)
    end

    private

    def type
      Types::DAILY
    end
  end
end
