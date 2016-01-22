require "habitica_cli/version"
require "habitica_cli/runner"

module HabiticaCli
  def self.start(*args)
    Runner.start(*args)
  end
end
