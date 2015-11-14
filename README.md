# RMB

[![Build Status](https://travis-ci.org/ifyouseewendy/rmb.svg?branch=master)](https://travis-ci.org/ifyouseewendy/rmb)
[![Code Climate](https://codeclimate.com/github/ifyouseewendy/rmb/badges/gpa.svg)](https://codeclimate.com/github/ifyouseewendy/rmb)
[![Test Coverage](https://codeclimate.com/github/ifyouseewendy/rmb/badges/coverage.svg)](https://codeclimate.com/github/ifyouseewendy/rmb/coverage)

RMB is a gem helps you generate money in Chinese Yuan.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'rmb_chinese_yuan'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install rmb_chinese_yuan

## Usage

```ruby
RMB.new(12345).convert              # => '壹万贰仟叁佰肆拾伍元'

# String argument is welcome
RMB.new('12345').convert            # => '壹万贰仟叁佰肆拾伍元'
RMB.new('1,234,567,890').convert    # => '壹拾贰亿叁仟肆佰伍拾陆万柒仟捌佰玖拾元'

# Decimal digits are supported
RMB.new(123.45).convert             # => '壹佰贰拾叁元肆角伍分'
RMB.new(0.55).convert               # => '伍角伍分'
RMB.new('.55').convert              # => '伍角伍分'

# Precision validates by 12 integers and 2 decimals
RMB.new('1234567890123').convert    # => ArgumentError: Integer part of money is longer than 12
RMB.new(1.155).convert              # => '壹元壹角伍分'

# Argument validation
RMB.new('hello mate').convert       # => ArgumentError: Not a valid money
RMB.new('-134').convert             # => ArgumentError: Not a valid money
```

## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).

