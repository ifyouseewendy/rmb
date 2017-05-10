require "codeclimate-test-reporter"
# CodeClimate::TestReporter.start
require 'bigdecimal'

$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)
require 'rmb_chinese_yuan'

require 'minitest/autorun'
