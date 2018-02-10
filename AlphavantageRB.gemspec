# lib = File.expand_path("../lib", __FILE__)
# $LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "rake"

Gem::Specification.new do |s|
  s.name        = "alphavantagerb"
  s.version	    = "1.2.0"
  s.authors     = ["Stefano Martin"]
  s.email       = ["stefano.martin87@gmail.com"]
  s.homepage    = "https://github.com/StefanoMartin/AlphaVantageRB"
  s.license     = "MIT"
  s.summary     = "A gem for Alpha Vantage"
  s.description = "A ruby wrapper for Alpha Vantage's HTTP API"
  s.platform	   = Gem::Platform::RUBY
  s.require_paths = ["lib"]
  s.files         = FileList["lib/*", "spec/**/*", "AlphavantageRB.gemspec", "Gemfile", "LICENSE.md", "README.md"].to_a
  s.add_dependency "httparty", "0.15.6"
  s.add_dependency "humanize", "1.7.0"
end
