module Alphavantage
  class Crypto_Timeseries
    include HelperFunctions

    def initialize market:, symbol:, datatype: "json", file: nil,
      key:, verbose: false
      check_argument([true, false], verbose, "verbose")
      @client = return_client(key, verbose)
      check_argument(["json", "csv"], datatype, "datatype")
      if datatype == "csv" && file.nil?
        raise Alphavantage::Error.new message: "No file specified where to save the CSV data"
      elsif datatype != "csv" && !file.nil?
        raise Alphavantage::Error.new message: "Hash error: No file necessary"
      end

      # @selected_time_series = which_series(type)
      url = "function=DIGITAL_CURRENCY_INTRADAY&symbol=#{symbol}&market=#{market}"
      return @client.download(url, file) if datatype == "csv"
      @hash = @client.request(url)
      metadata = @hash.dig("Meta Data") || {}
      metadata.each do |key, val|
        key_sym = key.downcase.gsub(/[0-9.]/, "").lstrip.gsub(" ", "_").to_sym
        define_singleton_method(key_sym) do
          return val
        end
      end
      @open = []; @high = []; @low = []; @close = []; @volume = [];
      @open_usd = []; @high_usd = []; @low_usd = []; @close_usd = [];
      @market_cap_usd = [];

      begin
        time_series = @hash.find{|key, val| key.include?("Time Series")}[1]
      rescue Exception => e
        raise Alphavantage::Error.new message: "No Time Series found: #{e.message}",
          data: @hash
      end

      series = {}
      convert_key = {}
      time_series.values[0].keys.each do |key|
        key_sym = recreate_metadata_key(key)
        series[key_sym] = []
        convert_key[key] = key_sym
      end
      time_series.each do |time, ts_hash|
        ts_hash.each do |key, value|
          series[convert_key[key]] << [time, value]
        end
      end
      series.keys.each do |key_sym|
        define_singleton_method(key_sym) do |*args|
          args ||= []
          return return_series(series[key_sym], args[0])
        end
      end
    end

    attr_reader :hash

    # def which_series(type)
    #   check_argument(["intraday", "daily", "weekly", "monthly"], type, "type")
    #   series = "DIGITAL_CURRENCY_"
    #   series += type.upcase
    #   return series
    # end
  end
end
