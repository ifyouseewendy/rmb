# RMB

RMB is a gem helps you generate money in Chinese Yuan.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'rmb'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install rmb

## Usage

```ruby
RMB.convert 12345             # => '壹万贰仟叁佰肆拾伍元'
RMB.convert '1,234,567,890'   # => '壹拾贰亿叁仟肆佰伍拾陆万柒仟捌佰玖拾元'
RMB.convert '1234567890123'   # => ArgumentError: Length over 12
```

## TODO

+ Refactor with better semantic methods
+ Add fraction support

## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).

