require "openssl"
OpenSSL::SSL::VERIFY_PEER = OpenSSL::SSL::VERIFY_NONE

require_relative "Alphavantage"

Alphavantage::AV.key = ""
msft = Alphavantage::AV.new symbol: "MSFT"
val = msft.intraday
msft2 = Alphavantage::Timeseries.new type: "daily", symbol: "MSFT"
val = msft2.information
msft3 = Alphavantage::Timeseries.new type: "daily", symbol: "AAPL", file: "ciao.csv", datatype: "csv"
