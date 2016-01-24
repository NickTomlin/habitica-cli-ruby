require 'thor'
require 'habitica_cli/api'
require 'habitica_cli/task'

module HabiticaCli
  # encapsulate our sub commands
  class Runner < Thor
    class_option :habit_user, default: ENV['HABIT_USER']
    class_option :habit_key, default: ENV['HABIT_KEY']

    desc 'task COMMAND', 'list, add, update dailies, todos, and habits'
    subcommand 'task', Task
  end
end
