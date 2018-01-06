module Alphavantage
  class Client
    include HelperFunctions

    def initialize key:, verbose: false
      check_argument([true, false], verbose, "verbose")
      @apikey = key
      @base_uri = 'https://www.alphavantage.co'
      @verbose = verbose
    end

    attr_reader :verbose

    def verbose=(verbose)
      check_argument([true, false], verbose, "verbose")
      @verbose = verbose
    end

    def request(url)
      send_url = "#{@base_uri}/query?#{url}&apikey=#{@apikey}"
      puts "\n#{send_url}\n" if @verbose
      begin
        response = HTTParty.get(send_url)
      rescue Exception => e
        raise Alphavantage::Error.new message: "Failed request: #{e.message}"
      end
      data = response.body
      begin
        data = JSON.parse(data)
      rescue Exception => e
        raise Alphavantage::Error.new message: "Parsing failed",
          data: data
      end
      if !data["Error Message"].nil?
        raise Alphavantage::Error.new message:  data["Error Message"], data: data
      elsif !data["Information"].nil?
        raise Alphavantage::Error.new message: data["Information"], data: data
      end
      return data
    end

    def download(url, file)
      send_url = "#{@base_uri}/query?#{url}&datatype=csv&apikey=#{@apikey}"
      begin
        puts send_url if @verbose
        uri = URI.parse(send_url)
        uri.open{|csv| IO.copy_stream(csv, file)}
      rescue Exception => e
        raise Alphavantage::Error.new message: "Failed to save the CSV file: #{e.message}"
      end
      return "CSV saved in #{file}"
    end

    def batch(symbols:, datatype: "json", file: nil)
      Alphavantage::Batch.new symbols: symbols, key: self, datatype: datatype, file: file
    end

    def stock(symbol:, datatype: "json")
      Alphavantage::Stock.new symbol: symbol, key: self, datatype: datatype
    end

    def exchange(from:, to:)
      Alphavantage::Exchange.new from: from, to: to, key: self
    end

    def crypto(symbol:, market:, datatype: "json")
      Alphavantage::Crypto.new symbol: symbol, key: self, datatype: datatype, market: market
    end

    def sector
      Alphavantage::Sector.new key: self
    end
  end
end
