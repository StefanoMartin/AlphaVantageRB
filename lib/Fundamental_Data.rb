module Alphavantage
  class Fundamental_Data
    include HelperFunctions

    def initialize(symbol:,  datatype: "json", key:, verbose: false)
      @client = return_client(key, verbose)
      @symbol = symbol
      @datatype = datatype
    end

    def overview(file: nil, datatype: @datatype)
      make_request(file: file, datatype: datatype, endpoint: 'OVERVIEW')
    end

    def income_statements(file: nil, datatype: @datatype, period: :both)
      payload = make_request(file: file, datatype: datatype, endpoint: 'INCOME_STATEMENT')

      return quarterly(payload) if period == :quarterly
      return annually(payload) if period == :annually
      payload
    end

    def balance_sheets(file: nil, datatype: @datatype, period: :both)
      payload = make_request(file: file, datatype: datatype, endpoint: 'BALANCE_SHEET')

      return quarterly(payload) if period == :quarterly
      return annually(payload) if period == :annually
      payload
    end

    def cash_flow_statements(file: nil, datatype: @datatype, period: :both)
      payload = make_request(file: file, datatype: datatype, endpoint: 'CASH_FLOW')

      return quarterly(payload) if period == :quarterly
      return annually(payload) if period == :annually
      payload
    end

    private

    def make_request(file: nil, datatype: @datatype, endpoint:)
      check_datatype(datatype, file)
      url = "function=#{endpoint}&symbol=#{@symbol}"
      return @client.download(url, file) if datatype == "csv"
      @client.request(url)
    end

    def quarterly(payload)
      payload['quarterlyReports']
    end

    def annually(payload)
      payload['annualReports']
    end
  end
end
