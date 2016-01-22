# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'habitica_cli/version'

Gem::Specification.new do |spec|
  spec.name          = 'habitica_cli'
  spec.version       = HabiticaCli::VERSION
  spec.authors       = ['Nick Tomlin']
  spec.email         = ['nick.tomlin@gmail.com']
  spec.summary       = 'A minimal CLI for habitica'
  spec.description   = 'Provides a minijmal highline based ruby cli for habitica' # rubocop:disable Metrics/LineLength
  spec.homepage      = 'https://github.com/nicktomlin/habitica-cli-ruby'
  spec.license       = 'MIT'

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables << 'habitica'
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ['lib']

  spec.add_dependency 'faraday', '~> 0.9.2'
  spec.add_dependency 'faraday_middleware', '~> 0.10.0'
  spec.add_dependency 'thor', '~> 0.19.1'

  spec.add_development_dependency 'bundler', '~> 1.7'
  spec.add_development_dependency 'rake', '~> 10.0'
  spec.add_development_dependency 'rubocop', '~> 0.36.0'
  spec.add_development_dependency 'rspec', '~> 3.4.0'
  spec.add_development_dependency 'webmock', '~> 1.22', '>= 1.22.6'
  spec.add_development_dependency 'pry'
end
