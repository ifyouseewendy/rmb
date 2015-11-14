require "rmb_chinese_yuan/version"

begin
  require "pry"
rescue LoadError
end

class RMB
  NUMBERS       = %w(零 壹 贰 叁 肆 伍 陆 柒 捌 玖)
  PART_UNIT     = %w(仟 佰 拾)
  INTEGER_UNIT  = %w(亿 万 元)
  DECIMAL_UNIT  = %w(整 角 分)

  attr_reader :integer, :decimal

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

      raise ArgumentError, "Not a valid money<#{money}>" \
        unless money.match(/^[\d|,|\.]+/)

      integer, decimal = money.gsub(',', '').split('.')
      decimal = decimal ? decimal[0,2] : ''

      raise ArgumentError, "Integer part of money<#{money}> is invalid" \
        unless integer.match(/^\d*$/)

      raise ArgumentError, "Decimal part of money<#{money}> is invalid" \
        unless decimal.match(/^\d*$/)

      raise ArgumentError, "Integer part of money<#{money}> is longer than 12" \
        if integer.length > 12

      [integer, decimal]
    end

    def convert_integer
      split_into_parts
      read_into_words
      join_words
    end

    def convert_decimal
      return DECIMAL_UNIT[0] if @decimal.to_i.zero?

      jiao, fen = @decimal.chars.map(&:to_i)
      res = ''

      if jiao.zero? && fen.to_i.nonzero?
        res << NUMBERS[jiao]
        res << [ NUMBERS[fen], DECIMAL_UNIT[2] ].join
      else
        res << [ NUMBERS[jiao], DECIMAL_UNIT[1] ].join
        res << [ NUMBERS[fen],  DECIMAL_UNIT[2] ].join if fen && fen.nonzero?
      end

      res
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
      @words = @parts.reduce([]){|ar, part| ar << read_integer(part) }
    end

    def read_integer(number)
      return NUMBERS[0] if number.zero?

      numbers = number.to_s.chars.map(&:to_i)
      numbers.unshift 0 while numbers.count < 4

      numbers.each_with_index.reduce('') do |str, (n, i)|
        if n.nonzero?
          str << [ NUMBERS[n], PART_UNIT[i] ].join
        elsif !str.empty? && i+1 < 4 && numbers[i+1].nonzero?
          str << NUMBERS[0]
        else
          str
        end
      end
    end

    def join_words
      res = ''

      yi, wan, ge = @parts

      res << [ @words[0], INTEGER_UNIT[0] ].join if yi.nonzero?

      if wan.zero?
        if yi.nonzero? && ge.nonzero?
          res << NUMBERS[0]
        end
      else
        if yi.nonzero? && (wan/1000).zero?
          res << NUMBERS[0]
        end
        res << [ @words[1], INTEGER_UNIT[1] ].join
      end

      if ge.zero?
        if yi.zero? && wan.zero?
          res << @words[2]
        end
      else
        if wan.nonzero? && (ge/1000).zero?
          res << NUMBERS[0]
        end
        res << @words[2]
      end

      res << INTEGER_UNIT[2]
    end
end
