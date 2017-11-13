require_relative './../../spec_helper'
require "openssl"
OpenSSL::SSL::VERIFY_PEER = OpenSSL::SSL::VERIFY_NONE

describe Alphavantage::Stock do
  context "#new" do
    it "create a new stock without client" do
      stock = Alphavantage::Stock.new symbol: "MSFT", key: @config["key"]
      expect(stock.class).to eq Alphavantage::Stock
    end

    it "create a new stock from client" do
      stock = @client.stock symbol: "MSFT"
      expect(stock.class).to eq Alphavantage::Stock
    end

    it "can change datatype" do
      bool = []
      stock = @client.stock symbol: "MSFT"
      bool << stock.datatype
      begin
        stock.datatype = "ciao"
      rescue Alphavantage::Error => e
        bool << "error"
      end
      stock.datatype = "csv"
      bool <<stock.datatype
      stock.datatype = "json"
      expect(bool).to eq ["json", "error", "csv"]
    end

    it "can create a new timeseries from stock" do
      stock = @client.stock symbol: "MSFT"
      timeseries = stock.timeseries
      expect(timeseries.class).to eq Alphavantage::Timeseries
    end
  end
end
