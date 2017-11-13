module Alphavantage
  class Client
    include HelperFunctions

    def initialize key:, verbose: false
      @apikey = key
      @base_uri = 'https://www.alphavantage.co'
      check_argument([true, false], verbose, "verbose")
      @verbose = verbose
    end

    attr_reader :verbose

    def verbose=(verbose)
      check_argument([true, false], verbose, "verbose")
      @verbose = verbose
    end

    def request(url)
      begin
        puts url if @verbose
        response = HTTParty.get("#{@base_uri}/#{url}&apikey=#{@apikey}")
      rescue Exception => e
        raise Alphavantage::Error.new message: "Failed request", error: e.message
      end
      data = response.body
      begin
        data = JSON.parse(data)
      rescue Exception => e
        raise Alphavantage::Error.new message: "Parsing failed",
          error: e.message, data: data
      end
      unless data["Error Message"].nil?
        raise Alphavantage::Error.new message: "Failed to retrieve data",
          error: data["Error Message"], data: data
      end
      return data
    end

    def download(url, file)
      begin
        puts url if @verbose
        uri = URI.parse("#{@base_uri}/#{url}&datatype=csv&apikey=#{@apikey}")
        uri.open{|csv| IO.copy_stream(csv, file)}
      rescue Exception => e
        raise Alphavantage::Error.new message: "Failed to save the CSV file",
          error: e.message
      end
      return "CSV saved in #{file}"
    end

    def stock(symbol:, datatype: "json")
      Alphavantage::Stock.new symbol: symbol, key: self, datatype: datatype
    end

    def exchange(from:, to:)
      Alphavantage::Exchange.new from: from, to: to, key: self
    end

    def crypto(symbol:, market:, datatype: "json")
      Alphavantage::Crypto.new symbol: symbol, key: self, datatype: datatype,
        market: market
    end

    def sector
      Alphavantage::Sector.new key: self
    end
  end
end
