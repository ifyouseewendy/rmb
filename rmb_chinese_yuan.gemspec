# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'rmb_chinese_yuan/version'

Gem::Specification.new do |spec|
  spec.name          = "rmb_chinese_yuan"
  spec.version       = RmbChineseYuan::VERSION
  spec.authors       = ["Di Wen"]
  spec.email         = ["ifyouseewendy@gmail.com"]

  spec.summary       = %q{RMB is a gem helps you generate money in Chinese Yuan.}
  spec.description   = %q{RMB is a gem helps you generate money in Chinese Yuan.}
  spec.homepage      = "http://github.com/ifyouseewendy/rmb"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.10"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "minitest"
  spec.add_development_dependency "pry-byebug"
end
