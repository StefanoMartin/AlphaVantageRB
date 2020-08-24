module Alphavantage
  class Fundamental_Data
    include HelperFunctions

    def initialize(symbol:,  datatype: "json", key:, verbose: false)
      check_argument([true, false], verbose, "verbose")
      @client = return_client(key, verbose)
      @symbol = symbol
      @datatype = datatype
    end

    def overview(file: nil, datatype: @datatype)
      check_argument(["json", "csv"], datatype, "datatype")
      make_request(file: file, datatype: datatype, endpoint: Endpoints::OVERVIEW)
    end

    def income_statements(file: nil, datatype: @datatype, period: :both)
      check_argument([:both, :quarterly, :annually], period, "period")
      payload = make_request(file: file, datatype: datatype, endpoint: Endpoints::INCOME_STATEMENT)

      extract_period_data(payload, period)
    end

    def balance_sheets(file: nil, datatype: @datatype, period: :both)
      check_argument([:both, :quarterly, :annually], period, "period")
      payload = make_request(file: file, datatype: datatype, endpoint: Endpoints::BALANCE_SHEET)

      extract_period_data(payload, period)
    end

    def cash_flow_statements(file: nil, datatype: @datatype, period: :both)
      check_argument([:both, :quarterly, :annually], period, "period")
      payload = make_request(file: file, datatype: datatype, endpoint: Endpoints::CASH_FLOW)

      extract_period_data(payload, period)
    end

    private

    def make_request(file: nil, datatype: @datatype, endpoint:)
      check_datatype(datatype, file)
      url = "function=#{endpoint}&symbol=#{@symbol}"
      return @client.download(url, file) if datatype == "csv"
      @client.request(url)
    end

    def extract_period_data(payload, period)
      return quarterly(payload) if period == :quarterly
      return annually(payload) if period == :annually
      payload # Return both periods in one hash
    end

    def quarterly(payload)
      payload['quarterlyReports']
    end

    def annually(payload)
      payload['annualReports']
    end
  end
end
