# EmPromise
[![Gem Version](https://badge.fury.io/rb/promise_em.svg)](https://badge.fury.io/rb/promise_em)
## Installation

Add this line to your application's Gemfile:

```ruby
gem 'promise_em'
```

And then execute:

    $ bundle install

Or install it yourself as:

    $ gem install promise_em

## Usage

Simple example with one deferrable

```ruby
EM.run do
  EmPromise::Promise.new do |resolve, _reject|
    puts 'new promise'
    EM::Timer.new(0.1) { resolve.call('hello') }
  end.then do |arg|
    puts arg
  end.catch do |*error|
    puts error
  end

  EM::Timer.new(0.5) { EM.stop }
end

# new promise
# hello
```

Example with few deferrable

```ruby
EM.run do
  EmPromise::Promise.new do |resolve, _reject|
    puts 'new promise'
    EM::Timer.new(0.1) { resolve.call('hello') }
  end.then do |arg|
    defer = EM::DefaultDeferrable.new
    puts arg
    EM::Timer.new(0.1) { defer.succeed('hello2') }
    defer
  end.then do |arg| 
    puts arg
    raise "error with arg #{arg}"
  end.catch do |*error|
    puts error
  end

  EM::Timer.new(0.5) { EM.stop }
end

# new promise
# hello
# hello2
# error with arg hello2
```

## Development

Run `rake` to run the tests and rubocop. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and the created tag, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/user1622/em_promise.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the EmPromise project's codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/[USERNAME]/em_promise/blob/master/CODE_OF_CONDUCT.md).
