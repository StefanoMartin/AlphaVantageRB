module Alphavantage
  class Timeseries
    include HelperFunctions
    def self.key=(key)
      @@apikey = key
    end

    def initialize type: "daily", interval: nil, outputsize: "compact", symbol:, datatype: "json", file: nil
      if type == "intraday"
        check_argument(["1min", "5min", "15min", "30min", "60min"], interval)
        interval = "&interval=#{interval}"
      else
        check_argument([nil], interval)
        interval = ""
      end
      check_argument(["compact", "full"], outputsize)
      check_argument(["json", "csv"], datatype)
      if datatype == "csv" && file.nil?
        raise "CSV error: No file specified where to save the data"
      elsif datatype != "csv" && !file.nil?
        raise "Hash error: No file necessary"
      end

      @selected_time_series = which_series(type)
      url = "query?function=#{@selected_time_series}&symbol=#{symbol}#{interval}&outputsize=#{outputsize}&apikey=#{@@apikey}"
      return download(url, file) if datatype == "csv"
      @hash = request(url)
      metadata = hash.dig("Meta Data") || {}
      metadata.each do |key, val|
        if key.include?("Information")
          @information = val
        elsif key.include?("Symbol")
          @symbol = val
        elsif key.include?("Last Refreshed")
          @last_refreshed = val
        elsif key.include?("Interval")
          @interval = val
        elsif key.include?("Output Size")
          @outputsize = val
        elsif key.include?("Time Zone")
          @timezone = val
        end
      end
      @open = []; @high = []; @low = []; @close = []; @volume = [];
      begin
        time_series = hash.find{|key, val| key.include?("Time Series")}[1]
      rescue Exception => e
        raise "No Time Series found: #{e.message}"
      end
      vol_num = type == "daily_adjusted" ? "6" : "5"
      time_series.each do |time, ts_hash|
        @open   << [time, ts_hash["1. open"]]
        @high   << [time, ts_hash["2. high"]]
        @low    << [time, ts_hash["3. low"]]
        @close  << [time, ts_hash["4. close"]]
        @volume << [time, ts_hash["#{vol_num}. volume"]]
        if type == "daily_adjusted"
          @adjusted_close << [time, ts_hash["5. adjusted close"]]
          @dividend_amount << [time, ts_hash["7. dividend amount"]]
          @split_coefficient << [time, ts_hash["8. split coefficient"]]
        end
      end
    end

    attr_reader :hash, :information, :symbol, :last_refreshed, :interval, :outputsize, :timezone

    def which_series(type)
      list = ["intraday", "daily", "daily", "daily_adjusted", "weekly", "monthly", "intraday"]
      case type
      when "daily"
        return "TIME_SERIES_DAILY"
      when "daily_adjusted"
        return "TIME_SERIES_DAILY_ADJUSTED"
      when "weekly"
        return "TIME_SERIES_WEEKLY"
      when "monthly"
        return "TIME_SERIES_MONTHLY"
      when "intraday"
        return "TIME_SERIES_INTRADAY"
      else
        raise  ArgumentError, "Only #{list.join(", ")} are supported"
      end
    end

    def return_series(series, order)
      check_argument(["asc", "desc"], order)
      return series.sort_by{ |hsh| hsh[0]} if order == "asc"
      return series
    end

    def open order: "desc"
      return_series(@open, order)
    end

    def high order: "desc"
      return_series(@high, order)
    end

    def low order: "desc"
      return_series(@low, order)
    end

    def close order: "desc"
      return_series(@close, order)
    end

    def volume order: "desc"
      return_series(@volume, order)
    end

    def adjusted_close order: "desc"
      return_series(@adjusted_close, order)
    end

    def dividend_amount order: "desc"
      return_series(@dividend_amount, order)
    end

    def split_coefficient order: "desc"
      return_series(@split_coefficient, order)
    end
  end
end
