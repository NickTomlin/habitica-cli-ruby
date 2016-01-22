require "thor"
require "habitica_cli/api"
require "habitica_cli/tasks/daily"
require "habitica_cli/tasks/todo"
require "habitica_cli/tasks/habit"

module HabiticaCli
  class Runner < Thor
    desc "daily COMMAND ...ARGS", "list or update dailies"
    subcommand "daily", Daily
    desc "todo COMMAND ...ARGS", "list or update todos"
    subcommand "todo", Todo
    desc "habit COMMAND ...ARGS", "list or update habits"
    subcommand "habit", Habit
  end
end
