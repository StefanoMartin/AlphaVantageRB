require_relative './../../spec_helper'
require "openssl"
OpenSSL::SSL::VERIFY_PEER = OpenSSL::SSL::VERIFY_NONE

describe Alphavantage::Exchange do
  context "#new" do
    it "create a new exchange without client" do
      exchange = Alphavantage::Exchange.new from: "USD", to: "DKK", key: @config["key"]
      expect(exchange.class).to eq Alphavantage::Exchange
    end

    it "create a new exchange with client" do
      exchange = @client.exchange from: "USD", to: "DKK"
      expect(exchange.class).to eq Alphavantage::Exchange
    end

    it "has several parameters" do
      exchange = @client.exchange from: "USD", to: "DKK"
      bool = []
      bool << (exchange.from_currency_code == "USD")
      bool << exchange.from_currency_name.is_a?(String)
      bool << (exchange.to_currency_code == "DKK")
      bool << exchange.to_currency_name.is_a?(String)
      bool << exchange.exchange_rate.is_a?(String)
      bool << exchange.last_refreshed.is_a?(String)
      bool << exchange.time_zone.is_a?(String)
      bool << exchange.hash.is_a?(Hash)
      expect(bool.all?{|e| e}).to eq true
    end

    it "cannot retrieve with wrong key" do
      error = false
      begin
        stock = Alphavantage::Exchange.new from: "USD", to: "DKK", key:"wrong_key"
      rescue Alphavantage::Error => e
        error = true
      end
      expect(error).to eq true
    end

    it "cannot retrieve with wrong symbol" do
      error = false
      begin
        stock = Alphavantage::Exchange.new from: "wrong_from", to: "DKK", key: @config["key"]
      rescue Alphavantage::Error => e
        error = true
      end
      expect(error).to eq true
    end
  end
end
