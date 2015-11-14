require 'test_helper'

class RMBTest < Minitest::Test
  def test_that_it_has_a_version_number
    refute_nil ::RmbChineseYuan::VERSION
  end

  def test_convert
    stubs = {
      0               => '零元',
      1               => '壹元',
      10              => '壹拾元',
      110             => '壹佰壹拾元',
      1000            => '壹仟元',
      1001            => '壹仟零壹元',
      1011            => '壹仟零壹拾壹元',
      1101            => '壹仟壹佰零壹元',
      1234            => '壹仟贰佰叁拾肆元',
      100000          => '壹拾万元',
      100001          => '壹拾万零壹元',
      100101          => '壹拾万零壹佰零壹元',
      110100          => '壹拾壹万零壹佰元',
      123456          => '壹拾贰万叁仟肆佰伍拾陆元',
      10000000        => '壹仟万元',
      10100100        => '壹仟零壹拾万零壹佰元',
      11010000        => '壹仟壹佰零壹万元',
      11010100        => '壹仟壹佰零壹万零壹佰元',
      11010101        => '壹仟壹佰零壹万零壹佰零壹元',
      12345678        => '壹仟贰佰叁拾肆万伍仟陆佰柒拾捌元',
      1000000000      => '壹拾亿元',
      1000000001      => '壹拾亿零壹元',
      1000001000      => '壹拾亿零壹仟元',
      1000001001      => '壹拾亿零壹仟零壹元',
      1000011001      => '壹拾亿零壹万壹仟零壹元',
      1001001001      => '壹拾亿零壹佰万壹仟零壹元',
      1001011001      => '壹拾亿零壹佰零壹万壹仟零壹元',
      1011011001      => '壹拾亿壹仟壹佰零壹万壹仟零壹元',
      100111011001    => '壹仟零壹亿壹仟壹佰零壹万壹仟零壹元',
      101011011001    => '壹仟零壹拾亿壹仟壹佰零壹万壹仟零壹元',
      111111111111    => '壹仟壹佰壹拾壹亿壹仟壹佰壹拾壹万壹仟壹佰壹拾壹元',
      123456789012    => '壹仟贰佰叁拾肆亿伍仟陆佰柒拾捌万玖仟零壹拾贰元',
      '1,234,567,890' => '壹拾贰亿叁仟肆佰伍拾陆万柒仟捌佰玖拾元'
    }
    stubs.each do |k,v|
      assert_equal v, RMB.new(k).convert
    end
  end

  def test_for_argument_check
    assert_raises ArgumentError, "Invalid argument" do
      RMB.new('No kidding').convert
    end

    assert_raises ArgumentError, "Negative number passed" do
      RMB.new(-134).convert
    end

    assert_raises ArgumentError, "Length over 12" do
      RMB.new('1234567890123').convert
    end
  end
end
