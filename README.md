# habitica-cli

A command line interface for habitica

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'habitica-cli'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install habitica-cli

## Usage

The cli needs your habitica user id and api key. You can configure these via the following:

- Setting/Exporting `HABIT_USER` and `HABIT_KEY` in your environment
- Using the `--habit-user` and `--habit-key` flags e.g. `habitica list --habit-user='user-id' --habit-key='user-api-key'`

```shell
habitica <command> <action>
```

## Contributing

```
bundle
# lint and run specs
rake

# run specs
rake spec

# lint
rake rubocop
```

1. Fork it ( https://github.com/[my-github-username]/habitica-cli/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
