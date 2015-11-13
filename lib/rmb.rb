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
      join(words)
    end

    # Public: Convert number under 9999
    #
    # number - String
    def meta_convert(number)
      return NUMBERS[0] if number.to_i == 0

      numbers = number.chars.map(&:to_i)
      numbers.unshift 0 while numbers.count < 4

      result = numbers.map.with_index { |num,idx|
        num == 0 ? NUMBERS[0] : [ NUMBERS[num], META_UNIT[idx] ].join
      }.join
      result = result.sub("#{NUMBERS[0]}#{NUMBERS[0]}#{NUMBERS[0]}", '')
      result = result.sub("#{NUMBERS[0]}#{NUMBERS[0]}", NUMBERS[0])
      result = result[1..-1] if result.start_with? NUMBERS[0]
      result = result[0..-2] if result.end_with? NUMBERS[0]

      result
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

        money
      end

      # Split money into three parts, each part is under 9999
      def split(number)
        parts = number.reverse.split(/(\d{4})/).reject(&:empty?).map(&:reverse).reverse
        parts.unshift '' while parts.count < 3
        parts
      end

      # Join words
      def join(words)
        res = ''
        res << [ words[0], PART_UNIT[0] ].join unless words[0] == NUMBERS[0]
        if words[1] == NUMBERS[0]
          res << ( res.empty? ? '' : NUMBERS[0] )
        else
          res << [ words[1], PART_UNIT[1] ].join
        end

        if words[2].start_with?(NUMBERS[0])
          res << [ words[2], PART_UNIT[2] ].join if res.empty?
        else
          res << NUMBERS[0] unless res.empty? || words[2].index(META_UNIT[0])
          res << [ words[2], PART_UNIT[2] ].join
        end

        res << SECTION_UNIT[0]
      end

  end
end
