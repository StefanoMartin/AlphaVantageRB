AlphavantageRB
=========================================================

[Alpha Vantage](https://www.alphavantage.co/) is a great API for retrieving Stock
market data in JSON or CSV format.
AlphavantageRB is a Gem to use Alpha Vantage with Ruby. AlphavangateRB is based
on the [HTTP API of Alpha Vantage](https://www.alphavantage.co/documentation/).

## Classes UNTESTED

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

<a name="Stock"></a>
## Alphavantage::Stock

Alphavantage::Stock is used to create a stock class to manage future retrieving of
timeseries or technical indicators.

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
  timeseries.hash
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

Note that the initialization owns different entries (for deeper explanation on the parameters, please consult the Alpha Vantage documentation):
* symbol: it is a string that denote the stock you want to retrieve. This value cannot be setup if you are initializing a timeseries from a stock
* key: authentication key.  This value cannot be setup if you are initializing a timeseries from a stock
* verbose: used to see the request to Alpha Vantage (default false). This value cannot be setup if you are initializing a timeseries from a stock
* function: it can be "SMA", "EMA", "WMA", "DEMA", "TEMA", "TRIMA", "KAMA", "T3",
  "RSI","MAMA", "MACD", "MACDEXT", "STOCH", "STOCHF", "STOCHRSI", "WILLR",
  "ADX", "ADXR", "APO", "PPO", "MOM", "BOP", "CCI", "CMO", "ROC", "ROCR",
  "AROON", "AROONOSC", "MFI", "TRIX", "ULTOSC", "DX", "MINUS_DI",
  "PLUS_DI", "MINUS_DM", "PLUS_DM", "BBANDS", "MIDPOINT", "MIDPRICE",
  "SAR", "TRANGE", "ATR", "NATR", "AD", "ADOSC", "OBV", "HT_SINE",
  "HT_TRENDLINE", "HT_TRENDMODE", "HT_DCPERIOD", "HT_DCPHASE", or
  "HT_PHASOR". Denote the type of function that you want to use.
* interval: it can be "1min", "5min", "15min", "30min", "60min", "daily", "weekly", or "monthly" (default "daily").
* time_period: it can be a positive integer (default "60"). These functions support this attribute: "SMA", "EMA", "WMA", "DEMA", "TEMA", "TRIMA", "KAMA", "T3", "RSI",
  "STOCHRSI", "WILLR", "ADX", "ADXR", "MOM", "CCI", "CMO", "ROC", "ROCR",
  "AROON", "AROONOSC", "MFI", "TRIX", "DX", "MINUS_DI", "PLUS_DI",
  "MINUS_DM", "PLUS_DM", "BBANDS", "MIDPOINT", "MIDPRICE", "ATR",
  "NATR"
* series_type: it can be "close", "open", "high", "low" (default "close"). These functions support this attribute: "SMA", "EMA", "WMA", "DEMA", "TEMA", "TRIMA", "KAMA", "T3", "RSI",
  "MAMA", "MACD", "MACDEXT", "STOCHRSI", "APO", "PPO", "MOM", "ROC",
  "ROCR", "TRIX", "BBANDS", "MIDPOINT", "HT_SINE", "HT_TRENDLINE",
  "HT_TRENDMODE", "HT_DCPERIOD", "HT_DCPHASE", "HT_PHASOR", "CMO"
* fastlimit:  it can be a positive float (default "0.01"). These function support this attribute: "MAMA"
* slowlimit: it can be a positive float (default "0.01"). This function supports this attribute: "MAMA"
* fastperiod:  it can be a positive integer (default "12"). These functions support this attribute: "MACD", "MACDEXT", "APO", "PPO", "ADOSC"
* slowperiod: it can be a positive integer (default "26"). These functions support this attribute: "MACD", "MACDEXT", "APO", "PPO", "ADOSC"
* signalperiod: it can be a positive integer (default "9"). These functions support this attribute: "MACD", "MACDEXT", "STOCH"
* fastmatype:  it can be "0", "1", "2", "3", "4", "5", "6", "7", "8", "SMA", "EMA", "WMA", "DEMA", "TEMA", "TRIMA", "T3", "KAMA", or "MAMA" (default "0"). This function supports this attribute: "MACDEXT"
* slowmatype: it can be "0", "1", "2", "3", "4", "5", "6", "7", "8", "SMA", "EMA", "WMA", "DEMA", "TEMA", "TRIMA", "T3", "KAMA", or "MAMA" (default "0"). This function supports this attribute: "MACDEXT"
* signalmatype: it can be "0", "1", "2", "3", "4", "5", "6", "7", "8", "SMA", "EMA", "WMA", "DEMA", "TEMA", "TRIMA", "T3", "KAMA", or "MAMA" (default "0"). This function supports this attribute: "MACDEXT"
* fastkperiod: it can be a positive integer (default "5"). These functions support this attribute: "STOCH", "STOCHRSI"
* slowkperiod: it can be a positive integer (default "3"). These functions support this attribute: "STOCH"
* slowdperiod: it can be a positive integer (default "3"). These functions support this attribute: "STOCH"
* slowkmatype: it can be "0", "1", "2", "3", "4", "5", "6", "7", "8", "SMA", "EMA", "WMA", "DEMA", "TEMA", "TRIMA", "T3", "KAMA", or "MAMA" (default "0"). These functions support this attribute: "STOCH"
* slowdmatype: it can be "0", "1", "2", "3", "4", "5", "6", "7", "8", "SMA", "EMA", "WMA", "DEMA", "TEMA", "TRIMA", "T3", "KAMA", or "MAMA" (default "0"). These functions support this attribute: "STOCH"
* fastdperiod: it can be a positive integer (default "3"). These functions support this attribute: "STOCH", "STOCHRSI"
* fastdmatype: it can be "0", "1", "2", "3", "4", "5", "6", "7", "8", "SMA", "EMA", "WMA", "DEMA", "TEMA", "TRIMA", "T3", "KAMA", or "MAMA" (default "0"). These functions support this attribute: "STOCH", "STOCHRSI"
* matype: it can be "0", "1", "2", "3", "4", "5", "6", "7", "8", "SMA", "EMA", "WMA", "DEMA", "TEMA", "TRIMA", "T3", "KAMA", or "MAMA" (default "0"). These functions support this attribute: "APO", "PPO", "BBANDS"
* timeperiod1: it can be a positive integer (default "7"). These functions support this attribute: "ULTOSC"
* timeperiod2: it can be a positive integer (default "14"). These functions support this attribute: "ULTOSC"
* timeperiod3:  it can be a positive integer (default "28"). These functions support this attribute: "ULTOSC"
* nbdevup: it can be a positive integer (default "2"). These functions support this attribute: "BBANDS"
* nbdevdn:  it can be a positive integer (default "2"). These functions support this attribute: "BBANDS"
* acceleration: it can be a positive float (default "0.01"). These functions support this attribute: "SAR"
* maximum: it can be a positive float (default "0.20"). These functions support this attribute: "SAR"

Each indicator has several methods that can use in relation of the type. Some are used for each indicator.
``` ruby
indicator = stock.indicator(function: "SMA", interval: "weekly", time_period: "60", series_type: "close")
indicator.hash # Retrieve the output from Alpha vantage
indicator.symbol
indicator.interval
indicator.indicator
indicator.last_refreshed
indicator.time_zone
```

Some other are more specific in relation of the type of indicator used.
``` ruby
indicator.time_period
=begin time_period is only supported by "SMA", "EMA", "WMA", "DEMA", "TEMA", "TRIMA", "KAMA", "T3", "RSI", "STOCHRSI", "WILLR", "ADX", "ADXR", "MOM", "CCI", "CMO", "ROC", "ROCR", "AROON", "AROONOSC", "MFI", "TRIX", "DX", "MINUS_DI", "PLUS_DI", "MINUS_DM", "PLUS_DM", "BBANDS", "MIDPOINT", "MIDPRICE", "ATR","NATR"
=end
indicator.series_type
=begin series_type is only supported by "SMA", "EMA", "WMA", "DEMA", "TEMA", "TRIMA", "KAMA", "T3", "RSI", "MAMA", "MACD", "MACDEXT", "STOCHRSI", "APO", "PPO", "MOM", "ROC","ROCR", "TRIX", "BBANDS", "MIDPOINT", "HT_SINE", "HT_TRENDLINE",  "HT_TRENDMODE", "HT_DCPERIOD", "HT_DCPHASE", "HT_PHASOR", "CMO"
=end
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
``` ruby
indicator = stock.indicator(function: "STOCHF", interval: "weekly", time_period: "60")
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
``` ruby
indicator = stock.indicator(function: "APO", interval: "weekly", series_type: "close", fastperiod: "12", slowperiod: "26", signalperiod: "9")
indicator.fast_period
indicator.slow_period
indicator.ma_type
indicator.apo
```

### PPO
``` ruby
indicator = stock.indicator(function: "PPO", interval: "weekly", series_type: "close", fastperiod: "12", slowperiod: "26", signalperiod: "9")
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


<a name="Crypto_Timeseries"></a>
<a name="Exchange"></a>
<a name="Sector"></a>
<a name="Error"></a>
