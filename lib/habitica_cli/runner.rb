require 'thor'
require 'habitica_cli/api'
require 'habitica_cli/tasks/daily'
require 'habitica_cli/tasks/todo'
require 'habitica_cli/tasks/habit'

module HabiticaCli
  # encapsulate our sub commands
  class Runner < Thor
    class_option :'habit_user', :default => ENV['HABIT_USER']
    class_option :'habit_key', :default => ENV['HABIT_KEY']

    desc 'daily COMMAND ...ARGS', 'list or update dailies'
    subcommand 'daily', Daily
    desc 'todo COMMAND ...ARGS', 'list or update todos'
    subcommand 'todo', Todo
    desc 'habit COMMAND ...ARGS', 'list or update habits'
    subcommand 'habit', Habit
  end
end
