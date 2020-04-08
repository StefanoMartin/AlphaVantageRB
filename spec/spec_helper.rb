require "rspec"
require "pry-byebug"
require "yaml"
require "openssl"
OpenSSL::SSL::VERIFY_PEER = OpenSSL::SSL::VERIFY_NONE
require "alphavantagerb"
# require_relative "../lib/alphavantagerb"

RSpec.configure do |config|
	config.color = true
	config.before(:all) do
		@config = YAML::load_file(File.join(__dir__, 'config.yml'))
		@client = Alphavantage::Client.new key: @config["key"]
		@stock = @client.stock(symbol: "MSFT")
	end
end
