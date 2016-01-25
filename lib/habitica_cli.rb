require 'habitica_cli/version'
require 'habitica_cli/task'

# A command line interface to habitica
# built on thor with a faraday based api layer
# you can use it to
# * create, complete, and list todos, habits, and dailies
module HabiticaCli
  def self.start(*args)
    Task.start(*args)
  end
end
