require 'open-uri'
require_relative "helper_function"
require_relative "Timeseries"
require_relative "Function"

module Alphavantage
  class AV
    include HelperFunctions
    include HTTParty
    base_uri 'https://www.alphavantage.co'

    def self.key=(key)
      @@apikey = key
      Alphavantage::Timeseries.key = key
      Alphavantage::Function.key = key
    end

    def initialize symbol:
      @symbol = symbol
      @datatype = "json"
    end

    attr_accessor :symbol

    def datatype=(datatype)
      check_argument(["json", "csv"], datatype)
      @datatype = datatype
    end

    def intraday interval: "1min", outputsize: "compact"
      Alphavantage::Timeseries.new type: "intraday", interval: interval,
        outputsize: outputsize, symbol: @symbol, datatype: @datatype
    end

    def daily outputsize: "compact"
      Alphavantage::Timeseries.new type: "daily",
        outputsize: outputsize, symbol: @symbol, datatype: @datatype
    end

    def daily_adjusted outputsize: "compact"
      Alphavantage::Timeseries.new type: "daily_adjusted",
        outputsize: outputsize, symbol: @symbol, datatype: @datatype
    end

    def weekly outputsize: "compact"
      Alphavantage::Timeseries.new type: "weekly",
        outputsize: outputsize, symbol: @symbol, datatype: @datatype
    end

    def monthly outputsize: "compact"
      Alphavantage::Timeseries.new type: "monthly",
        outputsize: outputsize, symbol: @symbol, datatype: @datatype
    end
  end
end
