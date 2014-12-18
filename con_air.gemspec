# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "con_air/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |spec|
  spec.name          = "con_air"
  spec.version       = ConAir::VERSION
  spec.authors       = ["Ngan Pham"]
  spec.email         = ["ngan@listia.com"]
  spec.homepage      = "https://github.com/listia/con_air"
  spec.summary       = %q{Connection hijacking for ActiveRecord.}
  spec.description   = %q{Connection hijacking for ActiveRecord}
  spec.license       = "MIT"

  spec.files         = Dir["{lib,spec}/**/*"].select { |f| File.file?(f) } +
                         %w(LICENSE.txt Rakefile README.md)

  spec.test_files    = spec.files.grep(%r{^spec/})
  spec.require_paths = ["lib"]

  spec.add_dependency "rails", "~> 4.0.12"

  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "rspec", "~> 3.1.0"
  spec.add_development_dependency "debugger", "~> 1.6"
  spec.add_development_dependency "sqlite3"
end
