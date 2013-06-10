# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'exchanger/version'

Gem::Specification.new do |spec|
  spec.name          = "exchanger"
  spec.version       = Exchanger::VERSION
  spec.authors       = ["Alexey Dulenko"]
  spec.email         = ["dulenkol@gmail.com"]
  spec.description   = %q{Gem works with exchange rates of the National Bank of Ukraine and the Central Bank of The Russian Federation}
  spec.summary       = %q{Gem takes information through the API of Private Bank}
  spec.homepage      = ""
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "rspec"
  spec.add_development_dependency "fakeweb"
  spec.add_dependency "nokogiri"
  spec.add_dependency "open-uri"
end
