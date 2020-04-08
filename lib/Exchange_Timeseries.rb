module Alphavantage
  class Exchange_Timeseries
    include HelperFunctions

    def initialize type: "intraday", from:, to:, datatype: "json", file: nil,
      key:, verbose: false, outputsize: "compact", interval: nil
      check_argument([true, false], verbose, "verbose")
      @client = return_client(key, verbose)
      if type == "intraday"
        interval ||= "1min"
        check_argument(["1min", "5min", "15min", "30min", "60min"], interval, "interval")
        interval = "&interval=#{interval}"
      else
        check_argument([nil], interval, "interval")
        interval = ""
      end
      check_argument(["compact", "full"], outputsize, "outputsize")
      check_argument(["json", "csv"], datatype, "datatype")
      check_datatype(datatype, file)

      @selected_time_series = which_series(type, "FX")
      url = "function=#{@selected_time_series}&from_symbol=#{from}&to_symbol=#{to}#{interval}&outputsize=#{outputsize}"
      return @client.download(url, file) if datatype == "csv"
      @output = @client.request(url)
      metadata = @output.dig("Meta Data") || {}
      metadata.each do |k, val|
        key_sym = k.downcase.gsub(/[0-9.]/, "").lstrip.gsub(" ", "_").to_sym
        define_singleton_method(key_sym) do
          return val
        end
      end
      @open = []; @high = []; @low = []; @close = [];

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
