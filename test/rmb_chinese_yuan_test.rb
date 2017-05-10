require 'test_helper'

class RmbChineseYuanTest < Minitest::Test
  def test_that_it_has_a_version_number
    refute_nil ::RmbChineseYuan::VERSION
  end

  def test_convert
    stubs = {
      0               => '零元整',
      1               => '壹元整',
      10              => '壹拾元整',
      110             => '壹佰壹拾元整',
      1000            => '壹仟元整',
      1001            => '壹仟零壹元整',
      1011            => '壹仟零壹拾壹元整',
      1101            => '壹仟壹佰零壹元整',
      1234            => '壹仟贰佰叁拾肆元整',
      100000          => '壹拾万元整',
      100001          => '壹拾万零壹元整',
      100101          => '壹拾万零壹佰零壹元整',
      110100          => '壹拾壹万零壹佰元整',
      123456          => '壹拾贰万叁仟肆佰伍拾陆元整',
      10000000        => '壹仟万元整',
      10100100        => '壹仟零壹拾万零壹佰元整',
      11010000        => '壹仟壹佰零壹万元整',
      11010100        => '壹仟壹佰零壹万零壹佰元整',
      11010101        => '壹仟壹佰零壹万零壹佰零壹元整',
      12345678        => '壹仟贰佰叁拾肆万伍仟陆佰柒拾捌元整',
      1000000000      => '壹拾亿元整',
      1000000001      => '壹拾亿零壹元整',
      1000001000      => '壹拾亿零壹仟元整',
      1000001001      => '壹拾亿零壹仟零壹元整',
      1000011001      => '壹拾亿零壹万壹仟零壹元整',
      1001001001      => '壹拾亿零壹佰万壹仟零壹元整',
      1001011001      => '壹拾亿零壹佰零壹万壹仟零壹元整',
      1011011001      => '壹拾亿壹仟壹佰零壹万壹仟零壹元整',
      100111011001    => '壹仟零壹亿壹仟壹佰零壹万壹仟零壹元整',
      101011011001    => '壹仟零壹拾亿壹仟壹佰零壹万壹仟零壹元整',
      111111111111    => '壹仟壹佰壹拾壹亿壹仟壹佰壹拾壹万壹仟壹佰壹拾壹元整',
      123456789012    => '壹仟贰佰叁拾肆亿伍仟陆佰柒拾捌万玖仟零壹拾贰元整',
      '1,234,567,890' => '壹拾贰亿叁仟肆佰伍拾陆万柒仟捌佰玖拾元整',
      1.11            => '壹元壹角壹分',
      1.10            => '壹元壹角',
      1.01            => '壹元零壹分',
      1.00            => '壹元整',
      1.001           => '壹元整',
      1.155           => '壹元壹角伍分',
      0.55            => '伍角伍分',
      '.55'           => '伍角伍分'
    }
    stubs.each do |k, v|
      assert_equal v, RMB.new(k).convert
    end
  end

  def test_for_bigdecimal
    price = BigDecimal.new("1234.01")
    assert_equal '壹仟贰佰叁拾肆元零壹分', RMB.new(price).convert
  end

  def test_for_argument_check
    assert_raises ArgumentError, 'Invalid argument' do
      RMB.new('No kidding').convert
    end

    assert_raises ArgumentError, 'Integer part of money is invalid' do
      RMB.new(-134).convert
    end

    assert_raises ArgumentError, 'Length over 12' do
      RMB.new('1234567890123').convert
    end
  end
end
