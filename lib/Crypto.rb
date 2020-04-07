module Alphavantage
  class Crypto
    include HelperFunctions

    def initialize symbol:, datatype: "json", key:, verbose: false, market:
      check_argument([true, false], verbose, "verbose")
      @client = return_client(key, verbose)
      @symbol = symbol
      @market = market
      @datatype = datatype
    end

    attr_accessor :symbol, :market
    attr_reader :datatype

    def datatype=(datatype)
      check_argument(["json", "csv"], datatype, "datatype")
      @datatype = datatype
    end

    def timeseries type: "daily", market: @market, file: nil, datatype: @datatype
      Alphavantage::Crypto_Timeseries.new type: type, market: market,
        symbol: @symbol, datatype: datatype, file: file, key: @client
    end
  end
end
