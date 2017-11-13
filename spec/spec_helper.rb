require "rspec"
require "pry-byebug"
require "yaml"
require_relative File.expand_path('../../lib/alphavantage', __FILE__)

RSpec.configure do |config|
	config.color = true
	config.before(:all) do
		@config = YAML::load_file(File.join(__dir__, 'config.yml'))
		@client = Alphavantage::Client.new key: @config["key"]
	end
end
