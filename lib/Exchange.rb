module Alphavantage
  class Exchange
    include HelperFunctions

    def initialize from:, to:, key:, verbose: false
      check_argument([true, false], verbose, "verbose")
      @client = return_client(key, verbose)
      @from = from
      @to = to
      @hash = @client.request("function=CURRENCY_EXCHANGE_RATE&from_currency=#{@from}&to_currency=#{@to}")
      hash = @hash["Realtime Currency Exchange Rate"]
      hash.each do |key, val|
        key_sym = recreate_metadata_key(key)
        define_singleton_method(key_sym) do
          return val
        end
      end
    end

    attr_reader :hash

  end
end
