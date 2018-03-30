module Alphavantage
  class Batch
    include HelperFunctions

    def initialize symbols:, datatype: "json", key:, verbose: false, file: nil
      check_argument([true, false], verbose, "verbose")
      symbols = [symbols] unless symbols.is_a?(Array)
      @client = return_client(key, verbose)
      @symbols = symbols
      @datatype = datatype
      @verbose = verbose
      @file = file
      check_argument(["json", "csv"], datatype, "datatype")
      if datatype == "csv" && file.nil?
        raise Alphavantage::Error.new message: "No file specified where to save the CSV ata"
      elsif datatype != "csv" && !file.nil?
        raise Alphavantage::Error.new message: "Hash error: No file necessary"
      end
      name_symbols = symbols.join(",")
      name_symbols.upcase!
      url = "function=BATCH_STOCK_QUOTES&symbols=#{name_symbols}"
      return @client.download(url, file) if datatype == "csv"
      @hash = @client.request(url)
      metadata = @hash.dig("Meta Data") || {}
      metadata.each do |key, val|
        key_sym = recreate_metadata_key(key)
        define_singleton_method(key_sym) do
          return val
        end
      end

      begin
        stock_quotes = @hash.find{|key, val| key.include?("Stock Quotes")}[1]
      rescue Exception => e
        raise Alphavantage::Error.new message: "No Stock Quotes found: #{e.message}",
          data: @hash
      end

      @stock_quotes = []
      stock_quotes.each do |sq|
        sval = {}
        sq.each do |key, val|
          key_sym = key.downcase.gsub(/[0-9.]/, "").lstrip.gsub(" ", "_")
          sval[key_sym] = val
        end
        @stock_quotes << sval
      end
    end

    attr_reader :datatype, :stock_quotes, :hash, :symbols
  end
end
