module Alphavantage
  class Sector
    include HelperFunctions

    def initialize key:, verbose: false
      check_argument([true, false], verbose, "verbose")
      @client = return_client(key, verbose)
      @hash = @client.request("function=SECTOR")
      metadata = @hash.dig("Meta Data") || {}
      metadata.each do |key, val|
        key_sym = key.downcase.gsub(/[0-9.]/, "").lstrip.gsub(" ", "_").to_sym
        define_singleton_method(key_sym) do
          return val
        end
      end
      @hash.each do |key, val|
        next if key == "Meta Data"
        key = key.split(":")[1].lstrip
        key = key.split(" ")
        if key[0].to_i != 0
          key[0] = key[0].to_i.humanize
        end
        key.delete_if{|k| k.include?("(")}
        key = key.join("_")
        key_sym = key.downcase.gsub("-", "_").to_sym
        define_singleton_method(key_sym) do
          return val
        end
      end
    end

    attr_reader :hash
  end
end
