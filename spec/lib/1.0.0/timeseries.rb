require_relative './../../spec_helper'

describe Alphavantage::Stock do
  context "#new" do
    it "create a new timeseries without stock" do
      stock = Alphavantage::Timeseries.new symbol: "MSFT", key: @config["key"], verbose: false
      expect(stock.class).to eq Alphavantage::Timeseries
    end

    it "create a new stock from stock" do
      timeseries = @client.stock(symbol: "MSFT").timeseries(type: "daily", outputsize: "compact")
      expect(timeseries.class).to eq Alphavantage::Timeseries
    end

    it "own multiple data" do
      timeseries = @client.stock(symbol: "MSFT").timeseries(type: "daily", outputsize: "full")
      bool = []
      bool << timeseries.information.is_a?(String)
      bool << (timeseries.symbol == "MSFT")
      bool << timeseries.last_refreshed.is_a?(String)
      bool << (timeseries.output_size == "Full size")
      bool << timeseries.time_zone.is_a?(String)
      bool << timeseries.output.is_a?(Hash)
      bool << timeseries.open.is_a?(Array)
      bool << timeseries.high.is_a?(Array)
      bool << timeseries.low.is_a?(Array)
      bool << timeseries.close.is_a?(Array)
      bool << timeseries.volume("asc").is_a?(Array)
      expect(bool.all?{|e| e}).to eq true
    end

    it "can retrieve intraday" do
      timeseries = @client.stock(symbol: "MSFT").timeseries(type: "intraday", interval: "30min")
      bool = []
      bool << timeseries.information.is_a?(String)
      bool << (timeseries.symbol == "MSFT")
      bool << timeseries.last_refreshed.is_a?(String)
      bool << (timeseries.interval == "30min")
      bool << (timeseries.output_size == "Compact")
      bool << timeseries.time_zone.is_a?(String)
      bool << timeseries.output.is_a?(Hash)
      bool << timeseries.open.is_a?(Array)
      bool << timeseries.high.is_a?(Array)
      bool << timeseries.low.is_a?(Array)
      bool << timeseries.close.is_a?(Array)
      bool << timeseries.volume("asc").is_a?(Array)
      expect(bool.all?{|e| e}).to eq true
    end

    it "can retrieve adjusted data" do
      timeseries = @client.stock(symbol: "MSFT").timeseries(type: "daily", outputsize: "compact", adjusted: true)
      bool = []
      bool << timeseries.information.is_a?(String)
      bool << (timeseries.symbol == "MSFT")
      bool << timeseries.last_refreshed.is_a?(String)
      bool << (timeseries.output_size == "Compact")
      bool << timeseries.time_zone.is_a?(String)
      bool << timeseries.output.is_a?(Hash)
      bool << timeseries.open.is_a?(Array)
      bool << timeseries.high.is_a?(Array)
      bool << timeseries.low.is_a?(Array)
      bool << timeseries.close.is_a?(Array)
      bool << timeseries.adjusted_close.is_a?(Array)
      bool << timeseries.dividend_amount.is_a?(Array)
      bool << timeseries.split_coefficient.is_a?(Array)
      bool << timeseries.volume("asc").is_a?(Array)
      expect(bool.all?{|e| e}).to eq true
    end

    it "can retrieve csv files" do
      bool = []
      directory = "#{__dir__}/test.csv"
      bool << File.exists?(directory)
      @client.stock(symbol: "MSFT").timeseries(type: "daily",
        outputsize: "compact", adjusted: true, datatype: "csv", file: directory)
      bool << File.exists?(directory)
      File.delete(directory)
      expect(bool).to eq [false, true]
    end

    # it "cannot retrieve with wrong key" do
    #   error = false
    #   begin
    #     stock = Alphavantage::Timeseries.new symbol: "MSFT", key:"wrong key"
    #   rescue Alphavantage::Error => e
    #     error = true
    #   end
    #   expect(error).to eq true
    # end

    it "cannot retrieve with wrong symbol" do
      error = false
      begin
        stock = Alphavantage::Timeseries.new symbol: "wrong_symbol", key: @config["key"]
      rescue Alphavantage::Error => e
        error = true
      end
      expect(error).to eq true
    end
  end
end
