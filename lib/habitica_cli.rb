require 'thor'
require 'ostruct'
require 'pstore'
require 'ostruct'
require 'kefir'
require 'faraday'
require 'faraday_middleware'
require 'habitica_cli/version'
require 'habitica_cli/config'
require 'habitica_cli/main'
require 'habitica_cli/api'
require 'habitica_cli/commands/shared'
require 'habitica_cli/commands/list'
require 'habitica_cli/commands/status'
require 'habitica_cli/commands/do'
require 'habitica_cli/commands/add'
require 'habitica_cli/commands/clear'
require 'habitica_cli/cache'

# A command line interface to habitica
# built on thor with a faraday based api layer
# you can use it to
# * create, complete, and list todos, habits, and dailies
module HabiticaCli
  def self.start(*args)
    Main.start(*args)
  end
end
