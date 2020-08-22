require_relative './../../spec_helper'

describe Alphavantage::Fundamental_Data do
  context "#new" do
    it "create a new fundamental data object without a client" do
      fd = Alphavantage::Fundamental_Data.new symbol: "MSFT", key: @config["key"]
      expect(fd.class).to eq Alphavantage::Fundamental_Data
    end

    it "create a new fundamental data object from client" do
      fd = @client.fundamental_data symbol: "MSFT"
      expect(fd.class).to eq Alphavantage::Fundamental_Data
    end
  end

  context 'core methods' do
    let(:fd) { @client.fundamental_data symbol: "MSFT" }

    it 'can retrieve an overview' do
      # fd = @client.fundamental_data symbol: "MSFT"
      overview = fd.overview
      expect(overview.class).to eq(Hash)
      expected_keys = ["Symbol", "AssetType", "Name", "Description", "Exchange", "Currency",
                     "Country", "Sector", "Industry", "Address", "FullTimeEmployees",
                     "FiscalYearEnd", "LatestQuarter", "MarketCapitalization", "EBITDA", "PERatio",
                     "PEGRatio", "BookValue", "DividendPerShare", "DividendYield", "EPS",
                     "RevenuePerShareTTM", "ProfitMargin", "OperatingMarginTTM",
                     "ReturnOnAssetsTTM", "ReturnOnEquityTTM", "RevenueTTM", "GrossProfitTTM",
                     "DilutedEPSTTM", "QuarterlyEarningsGrowthYOY", "QuarterlyRevenueGrowthYOY",
                     "AnalystTargetPrice", "TrailingPE", "ForwardPE", "PriceToSalesRatioTTM",
                     "PriceToBookRatio", "EVToRevenue", "EVToEBITDA", "Beta", "52WeekHigh",
                     "52WeekLow", "50DayMovingAverage", "200DayMovingAverage", "SharesOutstanding",
                     "SharesFloat", "SharesShort", "SharesShortPriorMonth", "ShortRatio",
                     "ShortPercentOutstanding", "ShortPercentFloat", "PercentInsiders",
                     "PercentInstitutions", "ForwardAnnualDividendRate", "ForwardAnnualDividendYield",
                     "PayoutRatio", "DividendDate", "ExDividendDate", "LastSplitFactor", "LastSplitDate"]
      expect(overview.keys).to eq(expected_keys)
    end

    context '#income_statements' do
      expected_keys = ["fiscalDateEnding", "reportedCurrency", "totalRevenue", "totalOperatingExpense",
                       "costOfRevenue", "grossProfit", "ebit", "netIncome", "researchAndDevelopment",
                       "effectOfAccountingCharges", "incomeBeforeTax", "minorityInterest",
                       "sellingGeneralAdministrative", "otherNonOperatingIncome", "operatingIncome",
                       "otherOperatingExpense", "interestExpense", "taxProvision", "interestIncome",
                       "netInterestIncome", "extraordinaryItems", "nonRecurring", "otherItems",
                       "incomeTaxExpense", "totalOtherIncomeExpense", "discontinuedOperations",
                       "netIncomeFromContinuingOperations", "netIncomeApplicableToCommonShares",
                       "preferredStockAndOtherAdjustments"]

      it 'can retrieve both statement types' do
        income_statements = fd.income_statements

        expect(income_statements.class).to eq(Hash)
        expect(income_statements.keys).to eq(["symbol", "annualReports", "quarterlyReports"])
        expect(income_statements["symbol"]).to eq("MSFT")
        ["annualReports", "quarterlyReports"].each do |period|
          income_statements[period].each do |report|
            expect(report.keys).to eq(expected_keys)
          end
        end
      end

      context 'retrieved quarterly' do
        it 'has the correct keys' do
          income_statements = fd.income_statements(period: :quarterly)

          expect(income_statements.class).to eq(Array)
          income_statements.each do |report|
            expect(report.keys).to eq(expected_keys)
          end
        end
      end

      context 'retrieved annually' do
        it 'has the correct keys' do
          income_statements = fd.income_statements(period: :annually)
          expect(income_statements.class).to eq(Array)
          income_statements.each do |report|
            expect(report.keys).to eq(expected_keys)
          end
        end
      end
    end

    context '#balance_sheets' do
      expected_keys = ["fiscalDateEnding", "reportedCurrency", "totalAssets", "intangibleAssets",
                       "earningAssets", "otherCurrentAssets", "totalLiabilities", "totalShareholderEquity",
                       "deferredLongTermLiabilities", "otherCurrentLiabilities", "commonStock",
                       "retainedEarnings", "otherLiabilities", "goodwill", "otherAssets", "cash",
                       "totalCurrentLiabilities", "shortTermDebt", "currentLongTermDebt",
                       "otherShareholderEquity", "propertyPlantEquipment", "totalCurrentAssets",
                       "longTermInvestments", "netTangibleAssets", "shortTermInvestments",
                       "netReceivables", "longTermDebt", "inventory", "accountsPayable",
                       "totalPermanentEquity", "additionalPaidInCapital", "commonStockTotalEquity",
                       "preferredStockTotalEquity", "retainedEarningsTotalEquity", "treasuryStock",
                       "accumulatedAmortization", "otherNonCurrrentAssets", "deferredLongTermAssetCharges",
                       "totalNonCurrentAssets", "capitalLeaseObligations", "totalLongTermDebt",
                       "otherNonCurrentLiabilities", "totalNonCurrentLiabilities", "negativeGoodwill",
                       "warrants", "preferredStockRedeemable", "capitalSurplus", "liabilitiesAndShareholderEquity",
                       "cashAndShortTermInvestments", "accumulatedDepreciation", "commonStockSharesOutstanding"]

      it 'can retrieve both statement types' do
        balance_sheets = fd.balance_sheets

        expect(balance_sheets.class).to eq(Hash)
        expect(balance_sheets.keys).to eq(["symbol", "annualReports", "quarterlyReports"])
        expect(balance_sheets["symbol"]).to eq("MSFT")
        ["annualReports", "quarterlyReports"].each do |period|
          balance_sheets[period].each do |report|
            expect(report.keys).to eq(expected_keys)
          end
        end
      end

      context 'retrieved quarterly' do
        it 'has the correct keys' do
          balance_sheets = fd.balance_sheets(period: :quarterly)

          expect(balance_sheets.class).to eq(Array)
          balance_sheets.each do |report|
            expect(report.keys).to eq(expected_keys)
          end
        end
      end

      context 'retrieved annually' do
        it 'has the correct keys' do
          balance_sheets = fd.balance_sheets(period: :annually)

          expect(balance_sheets.class).to eq(Array)
          balance_sheets.each do |report|
            expect(report.keys).to eq(expected_keys)
          end
        end
      end
    end

    context '#cash_flow_statements' do
      expected_keys = ["fiscalDateEnding", "reportedCurrency", "investments", "changeInLiabilities",
                       "cashflowFromInvestment", "otherCashflowFromInvestment", "netBorrowings",
                       "cashflowFromFinancing", "otherCashflowFromFinancing", "changeInOperatingActivities",
                       "netIncome", "changeInCash", "operatingCashflow", "otherOperatingCashflow",
                       "depreciation", "dividendPayout", "stockSaleAndPurchase", "changeInInventory",
                       "changeInAccountReceivables", "changeInNetIncome", "capitalExpenditures",
                       "changeInReceivables", "changeInExchangeRate", "changeInCashAndCashEquivalents"]


      it 'can retrieve both statement types' do
        cash_flow_statements = fd.cash_flow_statements

        expect(cash_flow_statements.class).to eq(Hash)
        expect(cash_flow_statements.keys).to eq(["symbol", "annualReports", "quarterlyReports"])
        expect(cash_flow_statements["symbol"]).to eq("MSFT")
        ["annualReports", "quarterlyReports"].each do |period|
          cash_flow_statements[period].each do |report|
            expect(report.keys).to eq(expected_keys)
          end
        end
      end

      context 'retrieved quarterly' do
        it 'has the correct keys' do
          cash_flow_statements = fd.cash_flow_statements(period: :quarterly)

          expect(cash_flow_statements.class).to eq(Array)
          cash_flow_statements.each do |report|
            expect(report.keys).to eq(expected_keys)
          end
        end
      end

      context 'retrieved annually' do
        it 'has the correct keys' do
          cash_flow_statements = fd.cash_flow_statements(period: :annually)

          expect(cash_flow_statements.class).to eq(Array)
          cash_flow_statements.each do |report|
            expect(report.keys).to eq(expected_keys)
          end
        end
      end
    end
  end
end
