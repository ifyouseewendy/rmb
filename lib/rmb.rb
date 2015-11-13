require "rmb/version"

begin
  require "pry"
rescue LoadError
end

module RMB
  NUMBERS       = %w(零 壹 贰 叁 肆 伍 陆 柒 捌 玖)
  META_UNIT     = %w(仟 佰 拾)
  PART_UNIT     = %w(亿 万)
  SECTION_UNIT  = %w(元 分)

  class << self
    def convert(money)
      number  = preprocess(money)
      parts   = split(number)
      words   = parts.map {|part| meta_convert(part) }
      join(parts, words)
    end

    # Public: Convert number under 9999
    #
    # number - String
    def meta_convert(number)
      return NUMBERS[0] if number.zero?

      res = ''

      thousand  = number / 1000
      hundred   = number / 100 % 10
      ten       = number / 10 % 10
      one       = number % 10

      # thousand
      res << [ NUMBERS[thousand], META_UNIT[0] ].join unless thousand.zero?

      # hundred
      if hundred.zero?
        if thousand.nonzero? && [ten, one].any?(&:nonzero?)
          res << NUMBERS[0]
        end
      else
        res << [ NUMBERS[hundred], META_UNIT[1] ].join
      end

      # ten
      if ten.zero?
        if hundred.nonzero? && one.nonzero?
          res << NUMBERS[0]
        end
      else
        res << [ NUMBERS[ten], META_UNIT[2] ].join
      end

      # one
      res << [ NUMBERS[one], META_UNIT[3] ].join unless one.zero?

      res
    end

    private

      # Private: Process for type conversion, and `,` substitution.
      #
      # money - String or positive Numberic, length should be less or equal than 12.
      def preprocess(money)
        money = money.to_s.gsub(',', '')

        raise ArgumentError, "Not a number<#{money}>" \
          unless money.match(/^\d+$/)

        raise ArgumentError, "Negative number<#{money}> passed" \
          if money.to_f < 0

        raise ArgumentError, "Length of money<#{money}> is longer than 12" \
          if money.to_s.length > 12

        money.to_i
      end

      # Split money into three parts, each part is under 9999
      def split(number)
        [
          number / 10**8,
          (number / 10**4) % 10**4,
          number % 10**4
        ]
      end

      # Join words
      def join(parts, words)
        res = ''

        yi, wan, ge = parts

        # yi
        res << [ words[0], PART_UNIT[0] ].join if yi.nonzero?

        # wan
        if wan.zero?
          if yi.nonzero? && ge.nonzero?
            res << NUMBERS[0]
          end
        else
          if yi.nonzero? && (wan/1000).zero?
            res << NUMBERS[0]
          end
          res << [ words[1], PART_UNIT[1] ].join
        end

        # ge
        if ge.zero?
          if yi.zero? && wan.zero?
            res << words[2]
          end
        else
          if wan.nonzero? && (ge/1000).zero?
            res << NUMBERS[0]
          end
          res << words[2]
        end

        res << SECTION_UNIT[0]
      end
  end
end
