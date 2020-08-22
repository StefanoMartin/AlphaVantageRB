module Alphavantage
  class Stock
    include HelperFunctions
    def initialize symbol:,  datatype: "json", key:, verbose: false
      check_argument([true, false], verbose, "verbose")
      @client = return_client(key, verbose)
      @symbol = symbol
      @datatype = datatype
    end

    attr_accessor :symbol
    attr_reader :datatype

    def datatype=(datatype)
      check_argument(["json", "csv"], datatype, "datatype")
      @datatype = datatype
    end

    def fundamental_data datatype: @datatype, file: nil
      Alphavantage::Fundamental_Data.new symbol: @symbol, key: @client, datatype: datatype
    end

    def quote file: nil, datatype: @datatype
      check_datatype(datatype, file)
      url = "function=GLOBAL_QUOTE&symbol=#{symbol}"
      return @client.download(url, file) if datatype == "csv"
      return open_struct(url, "Global Quote")
    end

    def timeseries type: "daily", interval: nil, outputsize: "compact",
      file: nil, datatype: @datatype, adjusted: false
      Alphavantage::Timeseries.new type: type, interval: interval,
        outputsize: outputsize, symbol: @symbol, datatype: datatype, file: file,
        key: @client, adjusted: adjusted
    end

    def indicator function:, interval: "daily", time_period: "60",
      series_type: "close", fastlimit: "0.01", slowlimit: "0.01",
      fastperiod: "12", slowperiod: "26", signalperiod: "9",
      fastmatype: "0", slowmatype: "0", signalmatype: "0",
      fastkperiod: "5", slowkperiod: "3", slowdperiod: "3",
      slowkmatype: "0", slowdmatype: "0", fastdperiod: "3",
      fastdmatype: "0", matype: "0", timeperiod1: "7", timeperiod2: "14",
      timeperiod3: "28", nbdevup: "2", nbdevdn: "2", acceleration: "0.01",
      maximum: "0.20"
      Alphavantage::Indicator.new function: function, symbol: @symbol,
        interval: interval, time_period: time_period, series_type: series_type,
        fastlimit: fastlimit, slowlimit: slowlimit, fastperiod: fastperiod,
        slowperiod: slowperiod, signalperiod: signalperiod,
        fastmatype: fastmatype, slowmatype: slowmatype,
        signalmatype: signalmatype, fastkperiod: fastkperiod, slowkperiod: slowkperiod,
        slowdperiod: slowdperiod, slowkmatype: slowkmatype, slowdmatype: slowdmatype,
        fastdperiod: fastdperiod, fastdmatype: fastdmatype, matype: matype,
        timeperiod1: timeperiod1, timeperiod2: timeperiod2, timeperiod3: timeperiod3,
        nbdevup: nbdevup, nbdevdn: nbdevdn, acceleration: acceleration,
        maximum: maximum, key: @client
    end
  end
end
