require_relative './../../spec_helper'

describe Alphavantage::Batch do
  context "#new" do
    it "create a new batch without client" do
      stock = Alphavantage::Batch.new symbols: ["MSFT", "FB", "AAPL"], key: @config["key"]
      expect(stock.class).to eq Alphavantage::Batch
    end

    it "create a new batch from client" do
      stock = @client.batch symbols: ["MSFT", "FB", "AAPL"]
      expect(stock.class).to eq Alphavantage::Batch
    end

    it "can change datatype" do
      bool = []
      stock = @client.batch symbols: ["MSFT", "FB", "AAPL"]
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

    it "own multiple data" do
      sleep(1); timeseries = @client.batch symbols: ["MSFT", "FB", "AAPL"]
      bool = []
      bool << timeseries.information.is_a?(String)
      bool << timeseries.notes.is_a?(String)
      bool << timeseries.time_zone.is_a?(String)
      bool << timeseries.stock_quote.is_a?(Array)
      expect(bool.all?{|e| e}).to eq true
    end

    it "can retrieve csv files" do
      bool = []
      directory = "#{__dir__}/test.csv"
      bool << File.exists?(directory)
      sleep(1); @client.batch(symbols: ["MSFT", "FB", "AAPL"], datatype: "csv", file: directory)
      bool << File.exists?(directory)
      File.delete(directory)
      expect(bool).to eq [false, true]
    end

    it "cannot retrieve with wrong symbol" do
      error = false
      begin
        sleep(1); stock = Alphavantage::Batch.new symbols: ["MSAFT", "FDB", "AAAPL"], key: @config["key"]
      rescue Alphavantage::Error => e
        error = true
      end
      expect(error).to eq true
    end
  end
end
