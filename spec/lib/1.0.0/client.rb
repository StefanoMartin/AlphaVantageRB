require_relative './../../spec_helper'

describe Alphavantage::Client do
  context "#new" do
    it "create a new client" do
      client = Alphavantage::Client.new key: @config["key"]
      expect(client.class).to eq Alphavantage::Client
    end

    it "can change verbose" do
      bool = []
      bool << @client.verbose
      begin
        @client.verbose = "ciao"
      rescue Alphavantage::Error => e
        bool << "error"
      end
      @client.verbose = true
      bool << @client.verbose
      @client.verbose = false
      expect(bool).to eq [false, "error", true]
    end

    it "can create a new stock from client" do
      stock = @client.stock symbol: "MSFT"
      expect(stock.class).to eq Alphavantage::Stock
    end

    it "can create a new exchange from client" do
      exchange = @client.exchange from: "USD", to: "DKK"
      expect(exchange.class).to eq Alphavantage::Exchange
    end

    it "can create a new crypto from client" do
      crypto = @client.crypto symbol: "BTC", market: "DKK"
      expect(crypto.class).to eq Alphavantage::Crypto
    end

    it "can create a new sector from client" do
      sector = @client.sector
      expect(sector.class).to eq Alphavantage::Sector
    end
  end
end
