AlphavantageRB [![Gem Version](https://badge.fury.io/rb/alphavantagerb.svg)](https://badge.fury.io/rb/alphavantagerb)
=========================================================

Last update: 8/4/2020

[Alpha Vantage](https://www.alphavantage.co/) is a great API for retrieving Stock
market data in JSON or CSV format.
AlphavantageRB is a Gem to use Alpha Vantage with Ruby. AlphavantageRB is based
on the [HTTP API of Alpha Vantage](https://www.alphavantage.co/documentation/).

To install AlphavantageRB: `gem install alphavantagerb`

To use it in your application: `require "alphavantagerb"`

## How to test

To test the Gem create a config.yml file inside the folder /spec with inside a line

``` ruby
key: [YOUR KEY]
```

Then run "rspec spec/test_all.rb".
Since AlphaVantage does not permit more than 5 request for minutes, many of your tests will fail. I advice either having a premium account or, like me, trying each file of test from the folder "spec/lib/1.0.0".

## Support

* Without a premium account, testing is hard and I could have missed something. Any bug, suggestions and improvements are more than welcome. Please do not be shy to create issues or pull requests.
* This is a personal project, any stars for giving your support will make a man happy.

## Thanks

Thank you to mruegenberg for his pull request.

## Classes

AlphavantateRB has the following classes:

* [Alphavantage::Client](#Client): to manage the credentials to contact Alpha
  Vantage
* [Alphavantage::Stock](#Stock): to create a stock class
* [Alphavantage::Timeseries](#Timeseries): to retrieve historical data of a stock
* [Alphavantage::Indicator](#Indicator): to use some technical indicator of a stock
* [Alphavantage::Crypto](#Crypto): to create a crypto currency class
* [Alphavantage::Crypto_Timeseries](#Crypto_Timeseries): to retrieve historical
  data of a crypto currency
* [Alphavantage::Exchange](#Exchange): to retrieve how a currency is exchanged currently on the market
* [Alphavantage::Exchange_Timeseries](#Exchange_Timeseries): to retrieve historical data of how a currency is exchanged currently on the market
* [Alphavantage::Sector](#Sector): to retrieve the status of the historical sector performances calculated from S&P500 incumbents
* [Alphavantage::Error](#Error): to manage AlphavantageRB errors

<a name="Client"></a>
## Alphavantage::Client

Alphavantage::Client is used to create a client that will be used from the AlphavantageRB to contact the website.
To contact Alpha Vantage you need to use a valid key that you can require from [here](https://www.alphavantage.co/support/#api-key).

To setup your credentials use:

``` ruby
client = Alphavantage::Client.new key: "YOURKEY"
```

If you want to see the request that the client will do to Alpha Vantage you can
setup verbose equal to true.

``` ruby
  client.verbose = true # You can setup this during the initialization too
```

You can use the method search to find some stocks by name.

``` ruby
  stocks_found = client.search keywords: "MSFT"
  stocks_found.output # Return the hash retrieved
```

This will return an array where each elements has the following structure:

``` ruby
  stocks_found.stocks[0].symbol
  stocks_found.stocks[0].name
  stocks_found.stocks[0].type
  stocks_found.stocks[0].region
  stocks_found.stocks[0].marketopen
  stocks_found.stocks[0].marketclose
  stocks_found.stocks[0].timezone
  stocks_found.stocks[0].currency
  stocks_found.stocks[0].matchscore
```

Furthermore you can retrieve its respective AlphaVantage::Stock instance by using:

``` ruby
  stocks_found.stocks[0].stock
```

<a name="Stock"></a>
## Alphavantage::Stock

Alphavantage::Stock is used to create a stock class to manage future retrieving of timeseries or technical indicators.

To create a new Stock class you can use a client or you can create it directly.
These two creation commands are equivalent:

``` ruby
stock = client.stock symbol: "MSFT"
stock = Alphavantage::Stock.new symbol: "MSFT", key: "YOURKEY"
```

Note that the initialization owns different entry:

* symbol: it is a string that denote the stock you want to retrieve.
* key: authentication key. This value cannot be setup if you are initializing a Stock class from a client
* verbose: used to see the request to Alpha Vantage (default false). This value cannot be setup if you are initializing a timeseries from a stock
* datatype: it can be "json" or "csv" (default "json")  

You can setup the datatype of future retrieving by doing:

``` ruby
  stock.datatype = "csv"
```

You can retrieve an Openstruct document of the actual status of the stock by using:

``` ruby
  stock_quote = stock.quote
```

This include different method with several information:

``` ruby
stock_quote.output # Output of the request
stock_quote.symbol
stock_quote.open
stock_quote.high
stock_quote.low
stock_quote.price
stock_quote.volume
stock_quote.latest_trading_day
stock_quote.previous_close
stock_quote.change
stock_quote.change_percent
```

<a name="Timeseries"></a>
## Alphavantage::Timeseries

Alphavantage::Timeseries is used to retrieve historical data.
To create a new Timeseries class you can use a Stock class or you can create it directly.
These two creation commands are equivalent:

``` ruby
timeseries = stock.timeseries
timeseries = Alphavantage::Timeseries.new symbol: "MSFT", key: "YOURKEY"
```

Note that the initialization owns different entries:

* symbol: it is a string that denote the stock you want to retrieve. This value cannot be setup if you are initializing a timeseries from a stock
* key: authentication key.  This value cannot be setup if you are initializing a timeseries from a stock
* verbose: used to see the request to Alpha Vantage (default false). This value cannot be setup if you are initializing a timeseries from a stock
* type: it can be "intraday", "daily", "weekly", "monthly" (default "daily")
* adjusted: a boolean value, it returns adjusted values (default false)
* interval: it can be "1min", "5min", "15min", "30min", or "60min". It is used
  only if type is "intraday" (default nil)
* outputsize: it can be "compact", or "full" (default "compact")
* datatype: it can be "json" or "csv" (default "json")
* file: path where a csv file should be saved (default "nil")

You can retrieve all the output from Alpha Vantage by doing.

``` ruby
  timeseries.output
```

Specific information about the timeseries can be retrieved using the following methods:

``` ruby
  timeseries.information # Retrieve information about the timeseries
  timeseries.symbol # Symbol used by the timeseries
  timeseries.last_refreshed # A timestamp that show when last time the data were refreshed
  timeseries.output_size # Size of the output
  timeseries.time_zone # Time zone of the timeseries
```

Specific data can be retrieved using the following methods.
These methods will return an array of couples where the first entry is a timestamp
and the second one is the value of the stock at the timestamp.

``` ruby
  timeseries.open
  timeseries.close
  timeseries.high
  timeseries.low
  timeseries.volume
  timeseries.adjusted_close # Available only if adjusted is true
  timeseries.dividend_amount # Available only if adjusted is true
  timeseries.split_coefficient # Available only if adjusted is true
```

You can order the data in ascending or descending order.

``` ruby
  timeseries.open("desc") # Default
  timeseries.open("asc")
```

<a name="Indicator"></a>
## Alphavantage::Indicator

Alphavantage::Indicator is for using technical indicator.
To create a new Indicator class you can use a Stock class or you can create it directly.
These two creation commands are equivalent:

``` ruby
indicator = stock.indicator function: "SMA"
indicator = Alphavantage::Indicator.new function: "SMA", symbol: "MSFT", key: "YOURKEY"
```

Note that the initialization owns different entries (for deeper explanation on the parameters, please consult the Alpha Vantage documentation).
Some of these parameters are necessary for each functions.

* symbol: it is a string that denote the stock you want to retrieve. This value cannot be setup if you are initializing a timeseries from a stock
* key: authentication key.  This value cannot be setup if you are initializing a timeseries from a stock
* verbose: used to see the request to Alpha Vantage (default false). This value cannot be setup if you are initializing a timeseries from a stock
* function: denote the type of function that you want to use. It can be "SMA", "EMA", "WMA", "DEMA", "TEMA", "TRIMA", "KAMA", "T3",  "RSI","MAMA", "MACD", "MACDEXT", "STOCH", "STOCHF", "STOCHRSI", "WILLR", "ADX", "ADXR", "APO", "PPO", "MOM", "BOP", "CCI", "CMO", "ROC", "ROCR", "AROON", "AROONOSC", "MFI", "TRIX", "ULTOSC", "DX", "MINUS_DI", "PLUS_DI", "MINUS_DM", "PLUS_DM", "BBANDS", "MIDPOINT", "MIDPRICE", "SAR", "TRANGE", "ATR", "NATR", "AD", "ADOSC", "OBV", "HT_SINE", "HT_TRENDLINE", "HT_TRENDMODE", "HT_DCPERIOD", "HT_DCPHASE", or "HT_PHASOR".
* interval: it can be "1min", "5min", "15min", "30min", "60min", "daily", "weekly", or "monthly" (default "daily").

Others are used only for some functions.

* time_period: it can be a positive integer (default "60"). These functions support this attribute: "SMA", "EMA", "WMA", "DEMA", "TEMA", "TRIMA", "KAMA", "T3", "RSI", "STOCHRSI", "WILLR", "ADX", "ADXR", "MOM", "CCI", "CMO", "ROC", "ROCR", "AROON", "AROONOSC", "MFI", "TRIX", "DX", "MINUS_DI", "PLUS_DI", "MINUS_DM", "PLUS_DM", "BBANDS", "MIDPOINT", "MIDPRICE", "ATR", "NATR"
* series_type: it can be "close", "open", "high", "low" (default "close"). These functions support this attribute: "SMA", "EMA", "WMA", "DEMA", "TEMA", "TRIMA", "KAMA", "T3", "RSI", "MAMA", "MACD", "MACDEXT", "STOCHRSI", "APO", "PPO", "MOM", "ROC", "ROCR", "TRIX", "BBANDS", "MIDPOINT", "HT_SINE", "HT_TRENDLINE", "HT_TRENDMODE", "HT_DCPERIOD", "HT_DCPHASE", "HT_PHASOR", "CMO"

Others are even more specific for the function used. These are in general of three type:
positive integer parameters, positive float parameters and MA parameters.
The MA parameters accept as an entry one of these attributes: "0", "1", "2", "3", "4", "5", "6", "7", "8", "SMA", "EMA", "WMA", "DEMA", "TEMA", "TRIMA", "T3", "KAMA", or "MAMA".

Each indicator has several methods that can use in relation of the type. Some are used for each indicator.

``` ruby
indicator = stock.indicator(function: "SMA", interval: "weekly", time_period: "60", series_type: "close")
indicator.output # Retrieve the output from Alpha vantage
indicator.symbol
indicator.interval
indicator.indicator
indicator.last_refreshed
indicator.time_zone
```

Some other are more specific in relation of the type of indicator used.

``` ruby
indicator.time_period # time_period is only supported by "SMA", "EMA", "WMA", "DEMA", "TEMA", "TRIMA", "KAMA", "T3", "RSI", "STOCHRSI", "WILLR", "ADX", "ADXR", "MOM", "CCI", "CMO", "ROC", "ROCR", "AROON", "AROONOSC", "MFI", "TRIX", "DX", "MINUS_DI", "PLUS_DI", "MINUS_DM", "PLUS_DM", "BBANDS", "MIDPOINT", "MIDPRICE", "ATR","NATR"
indicator.series_type # series_type is only supported by "SMA", "EMA", "WMA", "DEMA", "TEMA", "TRIMA", "KAMA", "T3", "RSI", "MAMA", "MACD", "MACDEXT", "STOCHRSI", "APO", "PPO", "MOM", "ROC","ROCR", "TRIX", "BBANDS", "MIDPOINT", "HT_SINE", "HT_TRENDLINE",  "HT_TRENDMODE", "HT_DCPERIOD", "HT_DCPHASE", "HT_PHASOR", "CMO"
```

Then there are really specific indicator, for only some functions.

### SMA

``` ruby
indicator = stock.indicator(function: "SMA", interval: "weekly", time_period: "60", series_type: "close")
indicator.sma
```

### EMA

``` ruby
indicator = stock.indicator(function: "EMA", interval: "weekly", time_period: "60", series_type: "close")
indicator.ema
```

### WMA

``` ruby
indicator = stock.indicator(function: "WMA", interval: "weekly", time_period: "60", series_type: "close")
indicator.wma
```

### DEMA

``` ruby
indicator = stock.indicator(function: "DEMA", interval: "weekly", time_period: "60", series_type: "close")
indicator.dema
```

### TEMA

``` ruby
indicator = stock.indicator(function: "TEMA", interval: "weekly", time_period: "60", series_type: "close")
indicator.tema
```

### TRIMA

``` ruby
indicator = stock.indicator(function: "TRIMA", interval: "weekly", time_period: "60", series_type: "close")
indicator.trima
```

### KAMA

``` ruby
indicator = stock.indicator(function: "KAMA", interval: "weekly", time_period: "60", series_type: "close")
indicator.kama
```

### MAMA

* fastlimit:  it can be a positive float (default "0.01")
* slowlimit: it can be a positive float (default "0.01")

``` ruby
indicator = stock.indicator(function: "MAMA", interval: "weekly", series_type: "close", fastlimit: "0.02", slowlimit: "0.01")
indicator.fast_limit
indicator.slow_limit
indicator.fama
indicator.mama
```

### T3

``` ruby
indicator = stock.indicator(function: "T3", interval: "weekly", time_period: "60", series_type: "close")
indicator.t3
```

### MACD

* fastperiod:  it can be a positive integer (default "12")
* slowperiod: it can be a positive integer (default "26")
* signalperiod: it can be a positive integer (default "9")

``` ruby
indicator = stock.indicator(function: "MACD", interval: "weekly",  time_period: "60", series_type: "close", fastperiod: "12", slowperiod: "26", signalperiod: "9")
indicator.fast_period
indicator.slow_period
indicator.signal_period
indicator.macd_signal
indicator.macd_hist
indicator.macd
```

### MACDEXT

* fastperiod:  it can be a positive integer (default "12")
* slowperiod: it can be a positive integer (default "26")
* signalperiod: it can be a positive integer (default "9")
* fastmatype:  it is a MA parameter (default "0")
* slowmatype: it is a MA parameter (default "0")
* signalmatype: it is a MA parameter (default "0")

``` ruby
indicator = stock.indicator(function: "MACDEXT", interval: "weekly",  time_period: "60", series_type: "close", fastperiod: "12", slowperiod: "26", signalperiod: "9", fastmatype: "0", slowmatype: "0", signalmatype: "0")
indicator.fast_period
indicator.slow_period
indicator.signal_period
indicator.signal_ma_type
indicator.fast_ma_type
indicator.slow_ma_type
indicator.macd_signal
indicator.macd_hist
indicator.macd
```

### STOCH

* fastkperiod: it can be a positive integer (default "5")
* slowkperiod: it can be a positive integer (default "3")
* slowdperiod: it can be a positive integer (default "3")
* slowkmatype: it is a MA parameter (default "0")
* slowdmatype: it is a MA parameter (default "0")

``` ruby
indicator = stock.indicator(function: "STOCH", interval: "weekly", fastkperiod: "5", slowkperiod: "3", slowdperiod: "3", slowkmatype: "0", slowdmatype: "0")
indicator.fastk_period
indicator.slowk_period
indicator.slowk_ma_type
indicator.slowd_period
indicator.slowd_ma_type
indicator.slowk
indicator.slowd
```

### STOCHF

* fastkperiod: it can be a positive integer (default "5")
* fastdperiod: it can be a positive integer (default "3")
* fastdmatype: it is a MA parameter (default "0")

``` ruby
indicator = stock.indicator(function: "STOCHF", interval: "weekly", fastkperiod: "5", fastdperiod: "3", fastdmatype: "0")
indicator.fastk_period
indicator.fastd_period
indicator.fastd_ma_type
indicator.fastk
indicator.fastd
```

### RSI

``` ruby
indicator = stock.indicator(function: "RSI", interval: "weekly", time_period: "60", series_type: "close")
indicator.rsi
```

### STOCHRSI

* fastkperiod: it can be a positive integer (default "5")
* fastdperiod: it can be a positive integer (default "3")
* fastdmatype: it is a MA parameter (default "0")

``` ruby
indicator = stock.indicator(function: "STOCHRSI", interval: "weekly", time_period: "60", fastkperiod: "5", fastdperiod: "3", fastdmatype: "0")
indicator.fastk_period
indicator.fastd_period
indicator.fastd_ma_type
indicator.fastk
indicator.fastd
```

### WILLR

``` ruby
indicator = stock.indicator(function: "WILLR", interval: "weekly", time_period: "60")
indicator.willr
```

### ADX

``` ruby
indicator = stock.indicator(function: "ADX", interval: "weekly", time_period: "60")
indicator.adx
```

### ADXR

``` ruby
indicator = stock.indicator(function: "ADXR", interval: "weekly", time_period: "60")
indicator.adxr
```

### APO

* fastperiod:  it can be a positive integer (default "12")
* slowperiod: it can be a positive integer (default "26")
* signalperiod: it can be a positive integer (default "9")
* matype: it is a MA parameter (default "0")

``` ruby
indicator = stock.indicator(function: "APO", interval: "weekly", series_type: "close", fastperiod: "12", slowperiod: "26", signalperiod: "9", matype: "0")
indicator.fast_period
indicator.slow_period
indicator.ma_type
indicator.apo
```

### PPO

* fastperiod:  it can be a positive integer (default "12")
* slowperiod: it can be a positive integer (default "26")
* signalperiod: it can be a positive integer (default "9")
* matype: it is a MA parameter (default "0")

``` ruby
indicator = stock.indicator(function: "PPO", interval: "weekly", series_type: "close", fastperiod: "12", slowperiod: "26", signalperiod: "9", matype: "0")
indicator.fast_period
indicator.slow_period
indicator.ma_type
indicator.ppo
```

### MOM

``` ruby
indicator = stock.indicator(function: "MOM", interval: "weekly", time_period: "60", series_type: "close")
indicator.mom
```

### BOP

``` ruby
indicator = stock.indicator(function: "MOM", interval: "weekly", time_period: "60", series_type: "close")
indicator.bop
```

### CCI

``` ruby
indicator = stock.indicator(function: "CCI", interval: "weekly", time_period: "60")
indicator.cci
```

### CMO

``` ruby
indicator = stock.indicator(function: "CMO", interval: "weekly", time_period: "60")
indicator.cmo
```

### ROC

``` ruby
indicator = stock.indicator(function: "ROC", interval: "weekly", time_period: "60", series_type: "close")
indicator.roc
```

### ROCR

``` ruby
indicator = stock.indicator(function: "ROCR", interval: "weekly", time_period: "60", series_type: "close")
indicator.rocr
```

### AROON

``` ruby
indicator = stock.indicator(function: "AROON", interval: "weekly", time_period: "60")
indicator.aroon_down
indicator.aroon_up
```

### AROONOSC

``` ruby
indicator = stock.indicator(function: "AROONOSC", interval: "weekly", time_period: "60")
indicator.aroonosc
```

### MFI

``` ruby
indicator = stock.indicator(function: "MFI", interval: "weekly", time_period: "60")
indicator.mfi
```

### TRIX

``` ruby
indicator = stock.indicator(function: "TRIX", interval: "weekly", time_period: "60", series_type: "close")
indicator.trix
```

### ULTOSC

* timeperiod1: it can be a positive integer (default "7")
* timeperiod2: it can be a positive integer (default "14")
* timeperiod3:  it can be a positive integer (default "28")

``` ruby
indicator = stock.indicator(function: "ULTOSC", interval: "weekly", timeperiod1: "7", timeperiod2: "14",  timeperiod3: "28")
indicator.time_period_1
indicator.time_period_2
indicator.time_period_3
indicator.ultosc
```

### DX

``` ruby
indicator = stock.indicator(function: "DX", interval: "weekly", time_period: "60")
indicator.dx
```

### MINUS_DI

``` ruby
indicator = stock.indicator(function: "MINUS_DI", interval: "weekly", time_period: "60")
indicator.minus_di
```

### PLUS_DI

``` ruby
indicator = stock.indicator(function: "PLUS_DI", interval: "weekly", time_period: "60")
indicator.plus_di
```

### MINUS_DM

``` ruby
indicator = stock.indicator(function: "PLUS_DI", interval: "weekly", time_period: "60")
indicator.minus_dm
```

### PLUS_DM

``` ruby
indicator = stock.indicator(function: "PLUS_DM", interval: "weekly", time_period: "60", series_type: "close")
indicator.plus_dm
```

### BBANDS

* matype: it is a MA parameter (default "0")
* nbdevup: it can be a positive integer (default "2")
* nbdevdn:  it can be a positive integer (default "2")

``` ruby
indicator = stock.indicator(function: "BBANDS", interval: "weekly", time_period: "60", series_type: "close", matype: "0", nbdevup: "2", nbdevdn: "2")
indicator.deviation_multiplier_for_upper_band
indicator.deviation_multiplier_for_lower_band
indicator.ma_type
indicator.real_lower_band
indicator.real_middle_band
indicator.real_upper_band
```

### MIDPOINT

``` ruby
indicator = stock.indicator(function: "MIDPOINT", interval: "weekly", time_period: "60", series_type: "close")
indicator.midpoint
```

### MIDPRICE

``` ruby
indicator = stock.indicator(function: "MIDPRICE", interval: "weekly", time_period: "60", series_type: "close")
indicator.midprice
```

### SAR

* acceleration: it can be a positive float (default "0.01")
* maximum: it can be a positive float (default "0.20")

``` ruby
indicator = stock.indicator(function: "SAR", interval: "weekly", acceleration: "0.01", maximum: "0.20")
indicator.acceleration
indicator.maximum
indicator.sar
```

### TRANGE

``` ruby
indicator = stock.indicator(function: "TRANGE", interval: "weekly")
indicator.trange
```

### ATR

``` ruby
indicator = stock.indicator(function: "ATR", interval: "weekly", time_period: "60")
indicator.atr
```

### NATR

``` ruby
indicator = stock.indicator(function: "NATR", interval: "weekly", time_period: "60")
indicator.natr
```

### AD

``` ruby
indicator = stock.indicator(function: "AD", interval: "weekly")
indicator.chaikin_ad
```

### ADOSC

* fastperiod:  it can be a positive integer (default "12")
* slowperiod: it can be a positive integer (default "26")

``` ruby
indicator = stock.indicator(function: "ADOSC", interval: "weekly", fastperiod: "12", slowperiod: "26")
indicator.fastk_period
indicator.slowk_period
indicator.adosc
```

### OBV

``` ruby
indicator = stock.indicator(function: "OBV", interval: "weekly")
indicator.obv
```

### HT_TRENDLINE

``` ruby
indicator = stock.indicator(function: "HT_TRENDLINE", interval: "weekly", time_period: "60", series_type: "close")
indicator.ht_trendline
```

### HT_SINE

``` ruby
indicator = stock.indicator(function: "HT_SINE", interval: "weekly", series_type: "close")
indicator.sine
indicator.lead_sine
```

### HT_TRENDMODE

``` ruby
indicator = stock.indicator(function: "HT_TRENDMODE", interval: "weekly", series_type: "close")
indicator.trendmode
```

### HT_DCPERIOD

``` ruby
indicator = stock.indicator(function: "HT_DCPERIOD", interval: "weekly", series_type: "close")
indicator.dcperiod
```

### HT_DCPHASE

``` ruby
indicator = stock.indicator(function: "EMA", interval: "weekly", series_type: "close")
indicator.ht_dcphase
```

### HT_PHASOR

``` ruby
indicator = stock.indicator(function: "HT_PHASOR", interval: "weekly", series_type: "close")
indicator.quadrature
indicator.phase
```

<a name="Crypto"></a>
## Alphavantage::Crypto

Alphavantage::Crypto is used to create a Crypto class to manage future retrieving of
timeseries of Cryptocurrency.

To create a new Crypto class you can use a client or you can create it directly.
These two creation commands are equivalent:

``` ruby
crypto = client.crypto symbol: "BTC", market: "DKK"
crypto = Alphavantage::Crypto.new symbol: "BTC", market: "DKK", key: "YOURKEY"
crypto.rating # Retrieve crypto ratings instance
```

Note that the initialization owns different entry:

* symbol: it is a string that denote the cryptocurrency you want to retrieve.
* market: denote the market where you want to analyze the cryptocurrency
* key: authentication key. This value cannot be setup if you are initializing a Stock class from a client
* verbose: used to see the request to Alpha Vantage (default false). This value cannot be setup if you are initializing a timeseries from a stock
* datatype: it can be "json" or "csv" (default "json")  

You can setup the datatype of future retrieving by doing:

``` ruby
crypto.datatype = "csv"
```

<a name="Crypto_Timeseries"></a>
## Alphavantage::Crypto_Timeseries

Alphavantage::Crypto_Timeseries is used to retrieve historical data of a cryptocurrency.
To create a new Crypto_Timeseries class you can use a Crypto class or you can create it directly.
These two creation commands are equivalent:

``` ruby
crypto_timeseries = crypto.timeseries type: "daily"
crypto_timeseries = Alphavantage::Crypto_Timeseries.new type: "daily", symbol: "BTC", market: "DKK", key: "YOURKEY"
```

Note that the initialization owns different entries:

* symbol: it is a string that denote the stock you want to retrieve. This value cannot be setup if you are initializing a timeseries from a crypto class from a crypto class
* market: it is a string that denote the market you want to analyse. This value cannot be setup if you are initializing a timeseries from a stock
* key: authentication key.  This value cannot be setup if you are initializing a timeseries from a crypto class
* verbose: used to see the request to Alpha Vantage (default false). This value cannot be setup if you are initializing a timeseries from a stock
* type: it can be "intraday", "daily", "weekly", "monthly" (default "daily")
* datatype: it can be "json" or "csv" (default "json")
* file: path where a csv file should be saved (default "nil")

You can retrieve all the output from Alpha Vantage by doing.

``` ruby
  crypto_timeseries.output
```

Specific information about the timeseries can be retrieved using the following methods:

``` ruby
  crypto_timeseries.information # Retrieve information about the timeseries
  crypto_timeseries.digital_currency_code # Code of the cryptocurrency
  crypto_timeseries.digital_currency_name # Name of the cryptocurrency
  crypto_timeseries.market_code # Code of the analysed market
  crypto_timeseries.market_name # Name of the analysed market
  crypto_timeseries.last_refreshed # A timestamp that show when last time the data were refreshed
  crypto_timeseries.output_size # Size of the output
  crypto_timeseries.time_zone # Time zone of the timeseries
```

Specific data can be retrieved using the following methods.
These methods will return an array of couples where the first entry is a timestampand the second one is the value of the stock at the timestamp.
These timeseries return always the corrispective timeseries in relation of the USD market.

``` ruby
  crypto_timeseries.open
  crypto_timeseries.close
  crypto_timeseries.high
  crypto_timeseries.low
  crypto_timeseries.volume
  crypto_timeseries.open_usd
  crypto_timeseries.close_usd
  crypto_timeseries.high_usd
  crypto_timeseries.low_usd
  crypto_timeseries.market_cap_usd
```

You can order the data in ascending or descending order.

``` ruby
  crypto_timeseries.open("desc") # Default
  crypto_timeseries.open("asc")
```

<a name="Exchange"></a>
## Alphavantage::Exchange

You can retrieve the exchange rate between two currencies (even cryptocurrency) by using this class.

To create a new Exchange class you can use a client or you can create it directly.
These two creation commands are equivalent:

``` ruby
exchange = client.exchange from: "USD", to: "DKK" # Check the value of a USD dollar in Danish Kr.
exchange = Alphavantage::Exchange.new from: "USD", to: "DKK", key: "YOURKEY"
```

Note that the initialization owns different entry:

* from: input currency you want to check the value (can be a crypto currency)
* to: output currency you want to see the value (can be a crypto currency)
* symbol: it is a string that denote the stock you want to retrieve.
* key: authentication key. This value cannot be setup if you are initializing a Stock class from a client
* verbose: used to see the request to Alpha Vantage (default false). This value cannot be setup if you are initializing a timeseries from a stock
* datatype: it can be "json" or "csv" (default "json")  

You can retrieve the actual situation of the exchange from Alpha Vantage by doing.

``` ruby
  ex_now = exchange.now
```

Other information can be retrieved using the following methods:

``` ruby
  ex_now.from_currency_code # Code of the from currency
  ex_now.from_currency_name # Name of the from currency
  ex_now.to_currency_code  # Code of the to currency
  ex_now.to_currency_name # Name of the to currency
  ex_now.exchange_rate # Exchange rate between the two currencies
  ex_now.information # Retrieve information about the timeseries
  ex_now.symbol # Symbol used by the timeseries
  exchange.last_refreshed # A timestamp that show when last time the data were refreshed
  ex_now.output_size # Size of the output
  ex_now.time_zone # Time zone of the timeseries
```

<a name="Exchange_Timeseries"></a>
## Alphavantage::Exchange_Timeseries

Alphavantage::Exchange_Timeseries is used to retrieve historical data of an exchange currency.
To create a new Exchange_Timeseries class you can use an Exchange class or you can create it directly.
These two creation commands are equivalent:

``` ruby
exchange_timeseries = exchange.timeseries type: "daily"
exchange_timeseries = Alphavantage::Exchange_Timeseries.new from: "USD", to: "DKK", key: "YOURKEY", type: "daily"
```

Note that the initialization owns different entries:

* symbol: it is a string that denote the stock you want to retrieve. This value cannot be setup if you are initializing a timeseries from a stock
* key: authentication key.  This value cannot be setup if you are initializing a timeseries from a stock
* verbose: used to see the request to Alpha Vantage (default false). This value cannot be setup if you are initializing a timeseries from a stock
* type: it can be "intraday", "daily", "weekly", "monthly" (default "daily")
* adjusted: a boolean value, it returns adjusted values (default false)
* interval: it can be "1min", "5min", "15min", "30min", or "60min". It is used
  only if type is "intraday" (default nil)
* outputsize: it can be "compact", or "full" (default "compact")
* datatype: it can be "json" or "csv" (default "json")
* file: path where a csv file should be saved (default "nil")

You can retrieve all the output from Alpha Vantage by doing.

``` ruby
  exchange_timeseries.output
```

Specific information about the timeseries can be retrieved using the following methods:

``` ruby
  exchange_timeseries.information # Retrieve information about the timeseries
  exchange_timeseries.from_symbol # Code of the from symbol
  exchange_timeseries.to_symbol # Code of the to symbol
  exchange_timeseries.last_refreshed # A timestamp that show when last time the data were refreshed
  exchange_timeseries.output_size # Size of the output
  exchange_timeseries.time_zone # Time zone of the timeseries
```

Specific data can be retrieved using the following methods.
These methods will return an array of couples where the first entry is a timestampand the second one is the value of the stock at the timestamp.
These timeseries return always the corrispective timeseries in relation of the USD market.

``` ruby
  exchange_timeseries.open
  exchange_timeseries.close
  exchange_timeseries.high
  exchange_timeseries.low
```

You can order the data in ascending or descending order.

``` ruby
  exchange_timeseries.open("desc") # Default
  exchange_timeseries.open("asc")
```

<a name="Sector"></a>
## Alphavantage::Sector
This class returns the realtime and historical sector performances calculated from S&P500 incumbents.

To create a new Sector class you can use a client or you can create it directly.
These two creation commands are equivalent:

``` ruby
sector = client.sector
sector = Alphavantage::Sector.new key: "YOURKEY"
```

Note that the initialization owns different entries:

* key: authentication key.  This value cannot be setup if you are initializing a timeseries from a crypto class

You can retrieve all the output from Alpha Vantage by doing.

``` ruby
  sector.output
```

Specific information about the timeseries can be retrieved using the following methods:

``` ruby
  sector.information
  sector.last_refreshed
  sector.real_time_performance
  sector.one_day_performance
  sector.five_day_performance
  sector.one_month_performance
  sector.three_month_performance
  sector.year_to_date_performance
  sector.one_year_performance
  sector.three_year_performance
  sector.five_year_performance
  sector.ten_year_performance
```

<a name="Error"></a>
## Alphavantage::Error

Errors are handled by this class.
You receive errors in the following cases:

* "Failed request": a request to Alpha Vantage fails
* "Parsing failed": the parsing of the JSON from Alpha Vantage fails
* A generic message from Alpha Vantage (for example by using a wrong key, a wrong query or too many requests at once). This message is equal as the one returned from Alpha Vantage API
* "Failed to save the CSV file": saving the CSV file failed
* "No file specified where to save the CSV data": you didn't specify a file to save your CSV data
* "Hash error: No file necessary": you specify a file to do a JSON request
* "No Time Series found": no timeseries has been retrieved from Alpha Vantage
* "[method] is undefined for [class]": you try to use a method not existing for the chosen class
* "Only [list] are supported for [attribute]": the attribute you are using for your request is not valid
* "Error: [value] is not a correct positive [integer/float]": you are not insering a positive integer or float (a value bigger and different than zero)
* "Key should be a string": you are trying to use a wrong key

You can retrieve more information from your error by using:

``` ruby
  e.message
  e.data # Data retrieved from Alpha vantage or further information to correct the error
```  
