module Alphavantage
  class Sector
    include HelperFunctions

    def initialize key:, verbose: false
      check_argument([true, false], verbose, "verbose")
      @client = return_client(key, verbose)
      @output = @client.request("function=SECTOR")
      metadata = @output.dig("Meta Data") || {}
      metadata.each do |k, val|
        key_sym = k.downcase.gsub(/[0-9.]/, "").lstrip.gsub(" ", "_").to_sym
        define_singleton_method(key_sym) do
          return val
        end
      end
      @output.each do |k, val|
        next if k == "Meta Data"
        k = k.split(":")[1].lstrip
        k = k.split(" ")
        if k[0].to_i != 0
          k[0] = k[0].to_i.humanize
        end
        k.delete_if{|ka| ka.include?("(")}
        k = k.join("_")
        key_sym = k.downcase.gsub("-", "_").to_sym
        define_singleton_method(key_sym) do
          return val
        end
      end
    end

    attr_reader :output
  end
end
