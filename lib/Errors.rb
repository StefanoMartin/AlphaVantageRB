module Alphavantage
  class Error < StandardError
    def initialize(message: , data: nil)
      @data = data
      super(message)
    end
    attr_reader :data
  end
end
