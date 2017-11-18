module Alphavantage
  class Timeseries
    include HelperFunctions

    def initialize type: "intraday", interval: nil, outputsize: "compact",
      symbol:, datatype: "json", file: nil, key:, verbose: false,
      adjusted: false
      check_argument([true, false], verbose, "verbose")
      @client = return_client(key, verbose)
      if type == "intraday"
        interval ||= "1min"
        check_argument(["1min", "5min", "15min", "30min", "60min"], interval, "interval")
        check_argument([false], adjusted, "adjusted")
        interval = "&interval=#{interval}"
      else
        check_argument([nil], interval, "interval")
        interval = ""
      end
      check_argument(["compact", "full"], outputsize, "outputsize")
      check_argument(["json", "csv"], datatype, "datatype")
      if datatype == "csv" && file.nil?
        raise Alphavantage::Error.new message: "No file specified where to save the CSV ata"
      elsif datatype != "csv" && !file.nil?
        raise Alphavantage::Error.new message: "Hash error: No file necessary"
      end

      @selected_time_series = which_series(type, adjusted)
      url = "function=#{@selected_time_series}&symbol=#{symbol}#{interval}&outputsize=#{outputsize}"
      return @client.download(url, file) if datatype == "csv"
      @hash = @client.request(url)
      metadata = @hash.dig("Meta Data") || {}
      metadata.each do |key, val|
        key_sym = key.downcase.gsub(/[0-9.]/, "").lstrip.gsub(" ", "_").to_sym
        define_singleton_method(key_sym) do
          return val
        end
      end

      begin
        time_series = @hash.find{|key, val| key.include?("Time Series")}[1]
      rescue Exception => e
        raise Alphavantage::Error.new message: "No Time Series found: #{e.message}",
          data: @hash
      end

      series = {}
      convert_key = {}
      time_series.values[0].keys.each do |key|
        key_sym = key.downcase.gsub(/[0-9.]/, "").lstrip.gsub(" ", "_").to_sym
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

    def which_series(type, adjusted)
      check_argument(["intraday", "daily", "weekly", "monthly"], type, "type")
      series = "TIME_SERIES_"
      series += type.upcase
      series += "_ADJUSTED" if adjusted
      return series
    end
  end
end
