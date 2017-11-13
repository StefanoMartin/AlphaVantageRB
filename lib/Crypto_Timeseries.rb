module Alphavantage
  class Crypto_Timeseries
    include HelperFunctions

    def initialize type: "intraday", market:, symbol:, datatype: "json", file: nil, key:, verbose: false
      @client = return_client(key, verbose)
      check_argument(["json", "csv"], datatype, "datatype")
      if datatype == "csv" && file.nil?
        raise Alphavantage::Error.new message: "No file specified where to save the CSV ata"
      elsif datatype != "csv" && !file.nil?
        raise Alphavantage::Error.new message: "Hash error: No file necessary"
      end

      @selected_time_series = which_series(type)
      url = "query?function=#{@selected_time_series}&symbol=#{symbol}&market=#{market}"
      return @client.download(url, file) if datatype == "csv"
      @hash = @client.request(url)
      metadata = hash.dig("Meta Data") || {}
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
        time_series = hash.find{|key, val| key.include?("Time Series")}[1]
      rescue Exception => e
        raise Alphavantage::Error.new message: "No Time Series found", error: e.message
      end

      series = {}
      convert_key = {}
      time_series.values[0].keys.each do |key|
        key_sym = key.split(" ")
        key_sym.shift
        key_sym = key_sym.join("_")
        key_sym = key_sym.downcase.gsub(/[0-9.]/, "").lstrip.gsub(" ", "_")
        key_sym = key_sym.split("_")
        if key_sym[-1] == "(usd)"
          key_sym[-1] = "usd"
        elsif key_sym[-1].include?("(") && key_sym[-1].include?(")")
          key_sym.pop
        end
        key_sym = key_sym.join("_")
        key_sym = key_sym.to_sym
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

    def which_series(type)
      check_argument(["intraday", "daily", "weekly", "monthly"], type, "type")
      series = "DIGITAL_CURRENCY_"
      series += type.upcase
      return series
    end
  end
end
