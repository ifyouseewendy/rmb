require 'rmb_chinese_yuan/version'

begin
  require 'pry'
rescue LoadError
end

class RMB
  NUMBERS       = %w(零 壹 贰 叁 肆 伍 陆 柒 捌 玖)
  PART_UNIT     = %w(仟 佰 拾)
  INTEGER_UNIT  = %w(亿 万 元)
  DECIMAL_UNIT  = %w(整 角 分)

  attr_reader :integer, :decimal, :parts, :words

  def initialize(money)
    @integer, @decimal = preprocess(money)
  end

  def convert
    join(convert_integer, convert_decimal)
  end

  private

    # Private: Process for type conversion, ',' substitution, and '.' split.
    def preprocess(money)
      money = money.to_s

      fail ArgumentError, "Not a valid money<#{money}>" \
        unless money.match(/^[\d|,|\.]+/)

      integer, decimal = money.delete(',').split('.')
      decimal = decimal ? decimal[0, 2] : ''

      fail ArgumentError, "Integer part of money<#{money}> is invalid" \
        unless integer.match(/^\d*$/)

      fail ArgumentError, "Decimal part of money<#{money}> is invalid" \
        unless decimal.match(/^\d*$/)

      fail ArgumentError, "Integer part of money<#{money}> is longer than 12" \
        if integer.length > 12

      [integer, decimal]
    end

    def convert_integer
      split_into_parts
      read_into_words
      join_words
    end

    def convert_decimal
      return DECIMAL_UNIT[0] if decimal.to_i.zero?

      jiao, fen = split_into_digits(decimal, direction: :tail, count: 2)

      if jiao.zero? && fen.nonzero?
        [NUMBERS[0], NUMBERS[fen], DECIMAL_UNIT[2]].join
      else
        res = [NUMBERS[jiao], DECIMAL_UNIT[1]].join
        res << [NUMBERS[fen],  DECIMAL_UNIT[2]].join if fen.nonzero?
        res
      end
    end

    def join(integer_words, decimal_words)
      if integer.to_i.zero? && decimal.to_i.nonzero?
        decimal_words
      else
        [integer_words, decimal_words].join
      end
    end

    # Split money into three parts, each part is under 9999
    def split_into_parts
      number = integer.to_i

      @parts = [
        number / 10**8,
        (number / 10**4) % 10**4,
        number % 10**4
      ]
    end

    def read_into_words
      @words = parts.reduce([]){ |ar, part| ar << read_integer(part) }
    end

    def read_integer(number)
      return NUMBERS[0] if number.zero?

      numbers = split_into_digits(number)

      numbers.each_with_index.reduce('') do |str, (n, i)|
        if n.nonzero?
          str << [NUMBERS[n], PART_UNIT[i]].join
        elsif !str.empty? && i + 1 < 4 && numbers[i+1].nonzero?
          str << NUMBERS[0]
        else
          str
        end
      end
    end

    def split_into_digits(number, direction: :head, count: 4)
      digits = number.to_s.chars.map(&:to_i)
      if direction == :head
        digits.unshift 0 while digits.count < count
      else
        digits.push 0 while digits.count < count
      end
      digits
    end

    def join_words
      res = [part_yi, part_wan, part_ge].join
      res << INTEGER_UNIT[2]
    end

    def part_yi
      [words[0], INTEGER_UNIT[0]].join unless parts[0].zero?
    end

    def part_wan
      yi, wan, ge = parts

      if wan.zero?
        if yi.nonzero? && ge.nonzero?
          NUMBERS[0]
        end
      else
        res = [words[1], INTEGER_UNIT[1]]
        res.unshift NUMBERS[0] if yi.nonzero? && (wan / 1000).zero?
        res.join
      end
    end

    def part_ge
      yi, wan, ge = parts

      if ge.zero?
        if yi.zero? && wan.zero?
          words[2]
        end
      else
        res = [words[2]]
        res.unshift NUMBERS[0] if wan.nonzero? && (ge / 1000).zero?
        res.join
      end

    end
end
