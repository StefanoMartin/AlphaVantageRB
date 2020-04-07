module Alphavantage
  class Crypto_Timeseries
    include HelperFunctions

    def initialize type: "daily", market:, symbol:, datatype: "json", file: nil,
      key:, verbose: false
      check_argument([true, false], verbose, "verbose")
      @client = return_client(key, verbose)
      check_argument(["json", "csv"], datatype, "datatype")
      check_datatype(datatype, file)

      @selected_time_series = which_series(type, "DIGITAL_CURRENCY")
      url = "function=#{@selected_time_series}&symbol=#{symbol}&market=#{market}"
      return @client.download(url, file) if datatype == "csv"
      @output = @client.request(url)
      metadata = @output.dig("Meta Data") || {}
      metadata.each do |keyt, val|
        key_sym = keyt.downcase.gsub(/[0-9.]/, "").lstrip.gsub(" ", "_").to_sym
        define_singleton_method(key_sym) do
          return val
        end
      end
      @open = []; @high = []; @low = []; @close = []; @volume = [];
      @open_usd = []; @high_usd = []; @low_usd = []; @close_usd = [];
      @market_cap_usd = [];

      begin
        time_series = @output.find{|k, val| k.include?("Time Series")}[1]
      rescue StandardError => e
        raise Alphavantage::Error.new message: "No Time Series found: #{e.message}",
          data: @output
      end

      series = {}
      convert_key = {}
      time_series.values[0].keys.each do |k|
        key_sym = recreate_metadata_key(k)
        series[key_sym] = []
        convert_key[k] = key_sym
      end
      time_series.each do |time, ts_hash|
        ts_hash.each do |k, value|
          series[convert_key[k]] << [time, value]
        end
      end
      series.keys.each do |key_sym|
        define_singleton_method(key_sym) do |*args|
          args ||= []
          return return_series(series[key_sym], args[0])
        end
      end
    end

    attr_reader :output
  end
end
