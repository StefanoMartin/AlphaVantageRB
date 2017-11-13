module Alphavantage
  class Error < StandardError
    def initialize(message: "Error in parsing JSON", data: nil, error: nil)
      @error = error
      @data = data
      super(message)
    end
    attr_reader :data, :error
  end
end
