module Alphavantage
  class Exchange
    include HelperFunctions

    def initialize from:, to:, key:, verbose: false,
      datatype: "json"
      check_argument([true, false], verbose, "verbose")
      @client = return_client(key, verbose)
      from = from.symbol if from.is_a?(Alphavantage::Crypto)
      to = to.symbol     if to.is_a?(Alphavantage::Crypto)
      @from = from
      @to = to
      check_argument(["json", "csv"], datatype, "datatype")
      @datatype = datatype
    end

    attr_accessor :from, :to
    attr_reader :datatype

    def datatype=(datatype)
      check_argument(["json", "csv"], datatype, "datatype")
      @datatype = datatype
    end

    def now(datatype: @datatype, file: nil)
      url = "function=CURRENCY_EXCHANGE_RATE&from_currency=#{@from}&to_currency=#{@to}"
      check_datatype(datatype, file)
      return @client.download(url, file) if datatype == "csv"
      return open_struct(url, "Realtime Currency Exchange Rate")
    end

    def timeseries from: @from, to: @to, type: "intraday", file: nil, datatype: @datatype, interval: nil, outputsize: "compact"
      Alphavantage::Exchange_Timeseries.new from: from, to: to, type: type, datatype: datatype, file: file, key: @client, interval: interval,
        outputsize: outputsize
    end
  end
end
