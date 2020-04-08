require_relative './../../spec_helper'

describe Alphavantage::Crypto do
  context "#new" do
    it "create a new crypto without client" do
      stock = Alphavantage::Crypto.new symbol: "BTC", key: @config["key"], market: "DKK"
      expect(stock.class).to eq Alphavantage::Crypto
    end

    it "create a new stock from client" do
      crypto = @client.crypto symbol: "BTC", market: "DKK"
      expect(crypto.class).to eq Alphavantage::Crypto
    end

    it "can change datatype" do
      bool = []
      stock = @client.crypto symbol: "BTC", market: "DKK"
      bool << stock.datatype
      begin
        stock.datatype = "ciao"
      rescue Alphavantage::Error => e
        bool << "error"
      end
      stock.datatype = "csv"
      bool << stock.datatype
      stock.datatype = "json"
      expect(bool).to eq ["json", "error", "csv"]
    end

    it "can create a new timeseries from stock" do
      stock = @client.crypto symbol: "BTC", market: "DKK"
      timeseries = stock.timeseries
      expect(timeseries.class).to eq Alphavantage::Crypto_Timeseries
    end

    it "can check its rating" do
      stock = @client.crypto symbol: "BTC", market: "DKK"
      rating = stock.rating
      expect(rating.symbol).to eq "BTC"
    end
  end
end
