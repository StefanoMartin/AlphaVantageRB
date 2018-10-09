 require_relative './../../spec_helper'

describe Alphavantage::Indicator do
  context "#new" do
    it "create a new indicator without stock" do
      indicator = Alphavantage::Indicator.new function: "SMA", symbol: "MSFT", key: @config["key"], verbose: false
      expect(indicator.class).to eq Alphavantage::Indicator
    end

    it "create a new stock from stock" do
      indicator = @client.stock(symbol: "MSFT").indicator(function: "SMA")
      expect(indicator.class).to eq Alphavantage::Indicator
    end

    it "can be indicator SMA" do
      bool = []
      indicator = @stock.indicator(function: "SMA", interval: "weekly", time_period: "60", series_type: "close")
      bool << (indicator.symbol == "MSFT")
      bool << indicator.indicator.is_a?(String)
      bool << indicator.last_refreshed.is_a?(String)
      bool << (indicator.interval == "weekly")
      bool << indicator.series_type.is_a?(String)
      bool << indicator.time_period.is_a?(Fixnum)
      bool << indicator.time_zone.is_a?(String)
      bool << indicator.sma.is_a?(Array)
      expect(bool.all?{|e| e}).to eq true
    end

    it "can be indicator EMA" do
      bool = []
      indicator = @stock.indicator(function: "EMA", interval: "weekly", time_period: "60", series_type: "close")
        bool << (indicator.symbol == "MSFT")
        bool << indicator.indicator.is_a?(String)
        bool << indicator.last_refreshed.is_a?(String)
        bool << (indicator.interval == "weekly")
        bool << indicator.series_type.is_a?(String)
        bool << indicator.time_zone.is_a?(String)
        bool << indicator.ema.is_a?(Array)
        expect(bool.all?{|e| e}).to eq true
    end

    it "can be indicator WMA" do
      bool = []
      indicator = @stock.indicator(function: "WMA", interval: "weekly", time_period: "60", series_type: "close")
        bool << (indicator.symbol == "MSFT")
        bool << indicator.indicator.is_a?(String)
        bool << indicator.last_refreshed.is_a?(String)
        bool << (indicator.interval == "weekly")
        bool << indicator.series_type.is_a?(String)
        bool << indicator.time_zone.is_a?(String)
        bool << indicator.wma.is_a?(Array)
        expect(bool.all?{|e| e}).to eq true
    end

    it "can be indicator DEMA" do
      bool = []
      indicator = @stock.indicator(function: "DEMA", interval: "weekly", time_period: "60", series_type: "close")
        bool << (indicator.symbol == "MSFT")
        bool << indicator.indicator.is_a?(String)
        bool << indicator.last_refreshed.is_a?(String)
        bool << (indicator.interval == "weekly")
        bool << indicator.series_type.is_a?(String)
        bool << indicator.time_zone.is_a?(String)
        bool << indicator.dema.is_a?(Array)
        expect(bool.all?{|e| e}).to eq true
    end

    it "can be indicator TEMA" do
      bool = []
      indicator = @stock.indicator(function: "TEMA", interval: "weekly",  time_period: "60", series_type: "close")
        bool << (indicator.symbol == "MSFT")
        bool << indicator.indicator.is_a?(String)
        bool << indicator.last_refreshed.is_a?(String)
        bool << (indicator.interval == "weekly")
        bool << indicator.series_type.is_a?(String)
        bool << indicator.time_zone.is_a?(String)
        bool << indicator.tema.is_a?(Array)
        expect(bool.all?{|e| e}).to eq true
    end

    it "can be indicator TRIMA" do
      bool = []
      indicator = @stock.indicator(function: "TRIMA", interval: "weekly", time_period: "60", series_type: "close")
        bool << (indicator.symbol == "MSFT")
        bool << indicator.indicator.is_a?(String)
        bool << indicator.last_refreshed.is_a?(String)
        bool << (indicator.interval == "weekly")
        bool << indicator.series_type.is_a?(String)
        bool << indicator.time_zone.is_a?(String)
        bool << indicator.trima.is_a?(Array)
        expect(bool.all?{|e| e}).to eq true
    end

    it "can be indicator KAMA" do
      bool = []
      indicator = @stock.indicator(function: "KAMA", interval: "weekly", time_period: "60", series_type: "close")
        bool << (indicator.symbol == "MSFT")
        bool << indicator.indicator.is_a?(String)
        bool << indicator.last_refreshed.is_a?(String)
        bool << (indicator.interval == "weekly")
        bool << indicator.series_type.is_a?(String)
        bool << indicator.time_zone.is_a?(String)
        bool << indicator.kama.is_a?(Array)
        expect(bool.all?{|e| e}).to eq true
    end

    it "can be indicator MAMA" do
      bool = []
      indicator = @stock.indicator(function: "MAMA", interval: "weekly", series_type: "close", fastlimit: "0.02", slowlimit: "0.01")
        bool << (indicator.symbol == "MSFT")
        bool << indicator.indicator.is_a?(String)
        bool << indicator.last_refreshed.is_a?(String)
        bool << (indicator.interval == "weekly")
        bool << (indicator.fast_limit == 0.02)
        bool << (indicator.slow_limit == 0.01)
        bool << indicator.series_type.is_a?(String)
        bool << indicator.time_zone.is_a?(String)
        bool << indicator.fama.is_a?(Array)
        bool << indicator.mama.is_a?(Array)
        expect(bool.all?{|e| e}).to eq true
    end

    it "can be indicator T3" do
      bool = []
      indicator = @stock.indicator(function: "T3", interval: "weekly", time_period: "60", series_type: "close")
        bool << (indicator.symbol == "MSFT")
        bool << indicator.indicator.is_a?(String)
        bool << indicator.last_refreshed.is_a?(String)
        bool << (indicator.interval == "weekly")
        bool << indicator.volume_factor.is_a?(Float)
        bool << indicator.series_type.is_a?(String)
        bool << indicator.time_zone.is_a?(String)
        bool << indicator.t3.is_a?(Array)
        expect(bool.all?{|e| e}).to eq true
    end

    it "can be indicator MACD" do
      bool = []
      indicator = @stock.indicator(function: "MACD", interval: "weekly",  time_period: "60", series_type: "close",        fastperiod: "12", slowperiod: "26", signalperiod: "9")
        bool << (indicator.symbol == "MSFT")
        bool << indicator.indicator.is_a?(String)
        bool << indicator.last_refreshed.is_a?(String)
        bool << (indicator.interval == "weekly")
        bool << indicator.fast_period.is_a?(Fixnum)
        bool << indicator.slow_period.is_a?(Fixnum)
        bool << indicator.signal_period.is_a?(Fixnum)
        bool << indicator.series_type.is_a?(String)
        bool << indicator.time_zone.is_a?(String)
        bool << indicator.macd_signal.is_a?(Array)
        bool << indicator.macd_hist.is_a?(Array)
        bool << indicator.macd.is_a?(Array)
        expect(bool.all?{|e| e}).to eq true
    end

    it "can be indicator MACDEXT" do
      bool = []
      indicator = @stock.indicator(function: "MACDEXT", interval: "weekly",  time_period: "60", series_type: "close", fastperiod: "12", slowperiod: "26", signalperiod: "9", fastmatype: "0", slowmatype: "0", signalmatype: "0")
        bool << (indicator.symbol == "MSFT")
        bool << indicator.indicator.is_a?(String)
        bool << indicator.last_refreshed.is_a?(String)
        bool << (indicator.interval == "weekly")
        bool << indicator.fast_period.is_a?(Fixnum)
        bool << indicator.slow_period.is_a?(Fixnum)
        bool << indicator.signal_period.is_a?(Fixnum)
        bool << indicator.series_type.is_a?(String)
        bool << indicator.signal_ma_type.is_a?(Fixnum)
        bool << indicator.fast_ma_type.is_a?(Fixnum)
        bool << indicator.slow_ma_type.is_a?(Fixnum)
        bool << indicator.time_zone.is_a?(String)
        bool << indicator.macd_signal.is_a?(Array)
        bool << indicator.macd_hist.is_a?(Array)
        bool << indicator.macd.is_a?(Array)
        expect(bool.all?{|e| e}).to eq true
    end

    it "can be indicator STOCH" do
      bool = []
      indicator = @stock.indicator(function: "STOCH", interval: "weekly", fastkperiod: "5", slowkperiod: "3", slowdperiod: "3", slowkmatype: "0", slowdmatype: "0")
        bool << (indicator.symbol == "MSFT")
        bool << indicator.indicator.is_a?(String)
        bool << indicator.last_refreshed.is_a?(String)
        bool << (indicator.interval == "weekly")
        bool << indicator.fastk_period.is_a?(Fixnum)
        bool << indicator.slowk_period.is_a?(Fixnum)
        bool << indicator.slowk_ma_type.is_a?(Fixnum)
        bool << indicator.slowd_period.is_a?(Fixnum)
        bool << indicator.slowd_ma_type.is_a?(Fixnum)
        bool << indicator.time_zone.is_a?(String)
        bool << indicator.slowk.is_a?(Array)
        bool << indicator.slowd.is_a?(Array)
        expect(bool.all?{|e| e}).to eq true
    end

    it "can be indicator STOCHF" do
      bool = []
      indicator = @stock.indicator(function: "STOCHF", interval: "weekly", fastkperiod: "5", fastdperiod: "3", fastdmatype: "0")
        bool << (indicator.symbol == "MSFT")
        bool << indicator.indicator.is_a?(String)
        bool << indicator.last_refreshed.is_a?(String)
        bool << (indicator.interval == "weekly")
        bool << indicator.fastk_period.is_a?(Fixnum)
        bool << indicator.fastd_period.is_a?(Fixnum)
        bool << indicator.fastd_ma_type.is_a?(Fixnum)
        bool << indicator.time_zone.is_a?(String)
        bool << indicator.fastk.is_a?(Array)
        bool << indicator.fastd.is_a?(Array)
        expect(bool.all?{|e| e}).to eq true
    end

    it "can be indicator RSI" do
      bool = []
      indicator = @stock.indicator(function: "RSI", interval: "weekly", time_period: "60", series_type: "close")
        bool << (indicator.symbol == "MSFT")
        bool << indicator.indicator.is_a?(String)
        bool << indicator.last_refreshed.is_a?(String)
        bool << (indicator.interval == "weekly")
        bool << indicator.series_type.is_a?(String)
        bool << indicator.time_zone.is_a?(String)
        bool << indicator.rsi.is_a?(Array)
        expect(bool.all?{|e| e}).to eq true
    end

    it "can be indicator STOCHRSI" do
      bool = []
      indicator = @stock.indicator(function: "STOCHRSI", interval: "weekly", time_period: "60", fastkperiod: "5", fastdperiod: "3", fastdmatype: "0")
        bool << (indicator.symbol == "MSFT")
        bool << indicator.indicator.is_a?(String)
        bool << indicator.last_refreshed.is_a?(String)
        bool << (indicator.interval == "weekly")
        bool << indicator.fastk_period.is_a?(Fixnum)
        bool << indicator.fastd_period.is_a?(Fixnum)
        bool << indicator.fastd_ma_type.is_a?(Fixnum)
        bool << indicator.time_zone.is_a?(String)
        bool << indicator.fastk.is_a?(Array)
        bool << indicator.fastd.is_a?(Array)
        expect(bool.all?{|e| e}).to eq true
    end

    it "can be indicator WILLR" do
      bool = []
      indicator = @stock.indicator(function: "WILLR", interval: "weekly", time_period: "60")
        bool << (indicator.symbol == "MSFT")
        bool << indicator.indicator.is_a?(String)
        bool << indicator.last_refreshed.is_a?(String)
        bool << (indicator.interval == "weekly")
        bool << indicator.time_zone.is_a?(String)
        bool << indicator.willr.is_a?(Array)
        expect(bool.all?{|e| e}).to eq true
    end

    it "can be indicator ADX" do
      bool = []
      indicator = @stock.indicator(function: "ADX", interval: "weekly", time_period: "60")
        bool << (indicator.symbol == "MSFT")
        bool << indicator.indicator.is_a?(String)
        bool << indicator.last_refreshed.is_a?(String)
        bool << (indicator.interval == "weekly")
        bool << indicator.time_zone.is_a?(String)
        bool << indicator.adx.is_a?(Array)
        expect(bool.all?{|e| e}).to eq true
    end

    it "can be indicator ADXR" do
      bool = []
      indicator = @stock.indicator(function: "ADXR", interval: "weekly", time_period: "60")
        bool << (indicator.symbol == "MSFT")
        bool << indicator.indicator.is_a?(String)
        bool << indicator.last_refreshed.is_a?(String)
        bool << (indicator.interval == "weekly")
        bool << indicator.time_zone.is_a?(String)
        bool << indicator.adxr.is_a?(Array)
        expect(bool.all?{|e| e}).to eq true
    end

    it "can be indicator APO" do
      bool = []
      indicator = @stock.indicator(function: "APO", interval: "weekly", series_type: "close", fastperiod: "12", slowperiod: "26", signalperiod: "9", matype: "0")
        bool << (indicator.symbol == "MSFT")
        bool << indicator.indicator.is_a?(String)
        bool << indicator.last_refreshed.is_a?(String)
        bool << (indicator.interval == "weekly")
        bool << indicator.fast_period.is_a?(Fixnum)
        bool << indicator.slow_period.is_a?(Fixnum)
        bool << indicator.ma_type.is_a?(Fixnum)
        bool << indicator.series_type.is_a?(String)
        bool << indicator.time_zone.is_a?(String)
        bool << indicator.apo.is_a?(Array)
        expect(bool.all?{|e| e}).to eq true
    end

    it "can be indicator PPO" do
      bool = []
      indicator = @stock.indicator(function: "PPO", interval: "weekly", series_type: "close", fastperiod: "12", slowperiod: "26", signalperiod: "9", matype: "0")
        bool << (indicator.symbol == "MSFT")
        bool << indicator.indicator.is_a?(String)
        bool << indicator.last_refreshed.is_a?(String)
        bool << (indicator.interval == "weekly")
        bool << indicator.fast_period.is_a?(Fixnum)
        bool << indicator.slow_period.is_a?(Fixnum)
        bool << indicator.ma_type.is_a?(Fixnum)
        bool << indicator.series_type.is_a?(String)
        bool << indicator.time_zone.is_a?(String)
        bool << indicator.ppo.is_a?(Array)
        expect(bool.all?{|e| e}).to eq true
    end

    it "can be indicator MOM" do
      bool = []
      indicator = @stock.indicator(function: "MOM", interval: "weekly", time_period: "60", series_type: "close")
        bool << (indicator.symbol == "MSFT")
        bool << indicator.indicator.is_a?(String)
        bool << indicator.last_refreshed.is_a?(String)
        bool << (indicator.interval == "weekly")
        bool << indicator.series_type.is_a?(String)
        bool << indicator.time_zone.is_a?(String)
        bool << indicator.mom.is_a?(Array)
        expect(bool.all?{|e| e}).to eq true
    end

    it "can be indicator BOP" do
      bool = []
      indicator = @stock.indicator(function: "BOP", interval: "weekly")
        bool << (indicator.symbol == "MSFT")
        bool << indicator.indicator.is_a?(String)
        bool << indicator.last_refreshed.is_a?(String)
        bool << (indicator.interval == "weekly")
        bool << indicator.time_zone.is_a?(String)
        bool << indicator.bop.is_a?(Array)
        expect(bool.all?{|e| e}).to eq true
    end

    it "can be indicator CCI" do
      bool = []
      indicator = @stock.indicator(function: "CCI", interval: "weekly", time_period: "60")
        bool << (indicator.symbol == "MSFT")
        bool << indicator.indicator.is_a?(String)
        bool << indicator.last_refreshed.is_a?(String)
        bool << (indicator.interval == "weekly")
        bool << indicator.time_zone.is_a?(String)
        bool << indicator.cci.is_a?(Array)
        expect(bool.all?{|e| e}).to eq true
    end

    it "can be indicator CMO" do
      bool = []
      indicator = @stock.indicator(function: "CMO", interval: "weekly", time_period: "60", series_type: "close")
        bool << (indicator.symbol == "MSFT")
        bool << indicator.indicator.is_a?(String)
        bool << indicator.last_refreshed.is_a?(String)
        bool << (indicator.interval == "weekly")
        bool << indicator.series_type.is_a?(String)
        bool << indicator.time_zone.is_a?(String)
        bool << indicator.cmo.is_a?(Array)
        expect(bool.all?{|e| e}).to eq true
    end

    it "can be indicator ROC" do
      bool = []
      indicator = @stock.indicator(function: "ROC", interval: "weekly", time_period: "60", series_type: "close")
        bool << (indicator.symbol == "MSFT")
        bool << indicator.indicator.is_a?(String)
        bool << indicator.last_refreshed.is_a?(String)
        bool << (indicator.interval == "weekly")
        bool << indicator.series_type.is_a?(String)
        bool << indicator.time_zone.is_a?(String)
        bool << indicator.roc.is_a?(Array)
        expect(bool.all?{|e| e}).to eq true
    end

    it "can be indicator ROCR" do
      bool = []
      indicator = @stock.indicator(function: "ROCR", interval: "weekly", time_period: "60", series_type: "close")
        bool << (indicator.symbol == "MSFT")
        bool << indicator.indicator.is_a?(String)
        bool << indicator.last_refreshed.is_a?(String)
        bool << (indicator.interval == "weekly")
        bool << indicator.series_type.is_a?(String)
        bool << indicator.time_zone.is_a?(String)
        bool << indicator.rocr.is_a?(Array)
        expect(bool.all?{|e| e}).to eq true
    end

    it "can be indicator AROON" do
      bool = []
      indicator = @stock.indicator(function: "AROON", interval: "weekly", time_period: "60")
        bool << (indicator.symbol == "MSFT")
        bool << indicator.indicator.is_a?(String)
        bool << indicator.last_refreshed.is_a?(String)
        bool << (indicator.interval == "weekly")
        bool << indicator.time_zone.is_a?(String)
        bool << indicator.aroon_down.is_a?(Array)
        bool << indicator.aroon_up.is_a?(Array)
        expect(bool.all?{|e| e}).to eq true
    end

    it "can be indicator AROONOSC" do
      bool = []
      indicator = @stock.indicator(function: "AROONOSC", interval: "weekly", time_period: "60")
        bool << (indicator.symbol == "MSFT")
        bool << indicator.indicator.is_a?(String)
        bool << indicator.last_refreshed.is_a?(String)
        bool << (indicator.interval == "weekly")
        bool << indicator.time_zone.is_a?(String)
        bool << indicator.aroonosc.is_a?(Array)
        expect(bool.all?{|e| e}).to eq true
    end

    it "can be indicator MFI" do
      bool = []
      indicator = @stock.indicator(function: "MFI", interval: "weekly", time_period: "60")
        bool << (indicator.symbol == "MSFT")
        bool << indicator.indicator.is_a?(String)
        bool << indicator.last_refreshed.is_a?(String)
        bool << (indicator.interval == "weekly")
        bool << indicator.time_zone.is_a?(String)
        bool << indicator.mfi.is_a?(Array)
        expect(bool.all?{|e| e}).to eq true
    end

    it "can be indicator TRIX" do
      bool = []
      indicator = @stock.indicator(function: "TRIX", interval: "weekly", time_period: "60", series_type: "close")
        bool << (indicator.symbol == "MSFT")
        bool << indicator.indicator.is_a?(String)
        bool << indicator.last_refreshed.is_a?(String)
        bool << (indicator.interval == "weekly")
        bool << indicator.series_type.is_a?(String)
        bool << indicator.time_zone.is_a?(String)
        bool << indicator.trix.is_a?(Array)
        expect(bool.all?{|e| e}).to eq true
    end

    it "can be indicator ULTOSC" do
      bool = []
      indicator = @stock.indicator(function: "ULTOSC", interval: "weekly", timeperiod1: "7", timeperiod2: "14",  timeperiod3: "28")
        bool << (indicator.symbol == "MSFT")
        bool << indicator.indicator.is_a?(String)
        bool << indicator.last_refreshed.is_a?(String)
        bool << (indicator.interval == "weekly")
        bool << indicator.time_zone.is_a?(String)
        bool << indicator.time_period_1.is_a?(Fixnum)
        bool << indicator.time_period_2.is_a?(Fixnum)
        bool << indicator.time_period_3.is_a?(Fixnum)
        bool << indicator.ultosc.is_a?(Array)
        expect(bool.all?{|e| e}).to eq true
    end

    it "can be indicator DX" do
      bool = []
      indicator = @stock.indicator(function: "DX", interval: "weekly", time_period: "60")
        bool << (indicator.symbol == "MSFT")
        bool << indicator.indicator.is_a?(String)
        bool << indicator.last_refreshed.is_a?(String)
        bool << (indicator.interval == "weekly")
        bool << indicator.time_zone.is_a?(String)
        bool << indicator.dx.is_a?(Array)
        expect(bool.all?{|e| e}).to eq true
    end

    it "can be indicator MINUS_DI" do
      bool = []
      indicator = @stock.indicator(function: "MINUS_DI", interval: "weekly", time_period: "60")
        bool << (indicator.symbol == "MSFT")
        bool << indicator.indicator.is_a?(String)
        bool << indicator.last_refreshed.is_a?(String)
        bool << (indicator.interval == "weekly")
        bool << indicator.time_zone.is_a?(String)
        bool << indicator.minus_di.is_a?(Array)
        expect(bool.all?{|e| e}).to eq true
    end

    it "can be indicator PLUS_DI" do
      bool = []
      indicator = @stock.indicator(function: "PLUS_DI", interval: "weekly", time_period: "60")
        bool << (indicator.symbol == "MSFT")
        bool << indicator.indicator.is_a?(String)
        bool << indicator.last_refreshed.is_a?(String)
        bool << (indicator.interval == "weekly")
        bool << indicator.time_zone.is_a?(String)
        bool << indicator.plus_di.is_a?(Array)
        expect(bool.all?{|e| e}).to eq true
    end

    it "can be indicator MINUS_DM" do
      bool = []
      indicator = @stock.indicator(function: "MINUS_DM", interval: "weekly", time_period: "60")
        bool << (indicator.symbol == "MSFT")
        bool << indicator.indicator.is_a?(String)
        bool << indicator.last_refreshed.is_a?(String)
        bool << (indicator.interval == "weekly")
        bool << indicator.time_zone.is_a?(String)
        bool << indicator.minus_dm.is_a?(Array)
        expect(bool.all?{|e| e}).to eq true
    end

    it "can be indicator PLUS_DM" do
      bool = []
      indicator = @stock.indicator(function: "PLUS_DM", interval: "weekly", time_period: "60")
        bool << (indicator.symbol == "MSFT")
        bool << indicator.indicator.is_a?(String)
        bool << indicator.last_refreshed.is_a?(String)
        bool << (indicator.interval == "weekly")
        bool << indicator.time_zone.is_a?(String)
        bool << indicator.plus_dm.is_a?(Array)
        expect(bool.all?{|e| e}).to eq true
    end

    it "can be indicator BBANDS" do
      bool = []
      indicator = @stock.indicator(function: "BBANDS", interval: "weekly", time_period: "60", series_type: "close", matype: "0", nbdevup: "2", nbdevdn: "2")
        bool << (indicator.symbol == "MSFT")
        bool << indicator.indicator.is_a?(String)
        bool << indicator.last_refreshed.is_a?(String)
        bool << (indicator.interval == "weekly")
        bool << indicator.series_type.is_a?(String)
        bool << indicator.time_zone.is_a?(String)
        bool << indicator.deviation_multiplier_for_upper_band.is_a?(Fixnum)
        bool << indicator.deviation_multiplier_for_lower_band.is_a?(Fixnum)
        bool << indicator.ma_type.is_a?(Fixnum)
        bool << indicator.real_lower_band.is_a?(Array)
        bool << indicator.real_middle_band.is_a?(Array)
        bool << indicator.real_upper_band.is_a?(Array)
        expect(bool.all?{|e| e}).to eq true
    end

    it "can be indicator MIDPOINT" do
      bool = []
      indicator = @stock.indicator(function: "MIDPOINT", interval: "weekly", time_period: "60", series_type: "close")
        bool << (indicator.symbol == "MSFT")
        bool << indicator.indicator.is_a?(String)
        bool << indicator.last_refreshed.is_a?(String)
        bool << (indicator.interval == "weekly")
        bool << indicator.series_type.is_a?(String)
        bool << indicator.time_zone.is_a?(String)
        bool << indicator.midpoint.is_a?(Array)
        expect(bool.all?{|e| e}).to eq true
    end

    it "can be indicator MIDPRICE" do
      bool = []
      indicator = @stock.indicator(function: "MIDPRICE", interval: "weekly", time_period: "60")
        bool << (indicator.symbol == "MSFT")
        bool << indicator.indicator.is_a?(String)
        bool << indicator.last_refreshed.is_a?(String)
        bool << (indicator.interval == "weekly")
        bool << indicator.time_zone.is_a?(String)
        bool << indicator.midprice.is_a?(Array)
        expect(bool.all?{|e| e}).to eq true
    end

    it "can be indicator SAR" do
      bool = []
      indicator = @stock.indicator(function: "SAR", interval: "weekly", acceleration: "0.01", maximum: "0.20")
        bool << (indicator.symbol == "MSFT")
        bool << indicator.indicator.is_a?(String)
        bool << indicator.last_refreshed.is_a?(String)
        bool << (indicator.interval == "weekly")
        bool << indicator.time_zone.is_a?(String)
        bool << indicator.acceleration.is_a?(Float)
        bool << indicator.maximum.is_a?(Float)
        bool << indicator.sar.is_a?(Array)
        expect(bool.all?{|e| e}).to eq true
    end

    it "can be indicator TRANGE" do
      bool = []
      indicator = @stock.indicator(function: "TRANGE", interval: "weekly")
        bool << (indicator.symbol == "MSFT")
        bool << indicator.indicator.is_a?(String)
        bool << indicator.last_refreshed.is_a?(String)
        bool << (indicator.interval == "weekly")
        bool << indicator.time_zone.is_a?(String)
        bool << indicator.trange.is_a?(Array)
        expect(bool.all?{|e| e}).to eq true
    end

    it "can be indicator ATR" do
      bool = []
      indicator = @stock.indicator(function: "ATR", interval: "weekly", time_period: "60")
        bool << (indicator.symbol == "MSFT")
        bool << indicator.indicator.is_a?(String)
        bool << indicator.last_refreshed.is_a?(String)
        bool << (indicator.interval == "weekly")
        bool << indicator.time_zone.is_a?(String)
        bool << indicator.atr.is_a?(Array)
        expect(bool.all?{|e| e}).to eq true
    end

    it "can be indicator NATR" do
      bool = []
      indicator = @stock.indicator(function: "NATR", interval: "weekly", time_period: "60")
        bool << (indicator.symbol == "MSFT")
        bool << indicator.indicator.is_a?(String)
        bool << indicator.last_refreshed.is_a?(String)
        bool << (indicator.interval == "weekly")
        bool << indicator.time_zone.is_a?(String)
        bool << indicator.natr.is_a?(Array)
        expect(bool.all?{|e| e}).to eq true
    end

    it "can be indicator AD" do
      bool = []
      indicator = @stock.indicator(function: "AD", interval: "weekly")
        bool << (indicator.symbol == "MSFT")
        bool << indicator.indicator.is_a?(String)
        bool << indicator.last_refreshed.is_a?(String)
        bool << (indicator.interval == "weekly")
        bool << indicator.time_zone.is_a?(String)
        bool << indicator.chaikin_ad.is_a?(Array)
        expect(bool.all?{|e| e}).to eq true
    end

    it "can be indicator ADOSC" do
      bool = []
      indicator = @stock.indicator(function: "ADOSC", interval: "weekly", fastperiod: "12", slowperiod: "26")
        bool << (indicator.symbol == "MSFT")
        bool << indicator.indicator.is_a?(String)
        bool << indicator.last_refreshed.is_a?(String)
        bool << (indicator.interval == "weekly")
        bool << indicator.fastk_period.is_a?(Fixnum)
        bool << indicator.slowk_period.is_a?(Fixnum)
        bool << indicator.time_zone.is_a?(String)
        bool << indicator.adosc.is_a?(Array)
        expect(bool.all?{|e| e}).to eq true
    end

    it "can be indicator OBV" do
      bool = []
      indicator = @stock.indicator(function: "OBV", interval: "weekly")
        bool << (indicator.symbol == "MSFT")
        bool << indicator.indicator.is_a?(String)
        bool << indicator.last_refreshed.is_a?(String)
        bool << (indicator.interval == "weekly")
        bool << indicator.time_zone.is_a?(String)
        bool << indicator.obv.is_a?(Array)
        expect(bool.all?{|e| e}).to eq true
    end

    it "can be indicator HT_TRENDLINE" do
      bool = []
      indicator = @stock.indicator(function: "HT_TRENDLINE", interval: "weekly", series_type: "close")
        bool << (indicator.symbol == "MSFT")
        bool << indicator.indicator.is_a?(String)
        bool << indicator.last_refreshed.is_a?(String)
        bool << (indicator.interval == "weekly")
        bool << indicator.series_type.is_a?(String)
        bool << indicator.time_zone.is_a?(String)
        bool << indicator.ht_trendline.is_a?(Array)
        expect(bool.all?{|e| e}).to eq true
    end

    it "can be indicator HT_SINE" do
      bool = []
      indicator = @stock.indicator(function: "HT_SINE", interval: "weekly", series_type: "close")
        bool << (indicator.symbol == "MSFT")
        bool << indicator.indicator.is_a?(String)
        bool << indicator.last_refreshed.is_a?(String)
        bool << (indicator.interval == "weekly")
        bool << indicator.series_type.is_a?(String)
        bool << indicator.time_zone.is_a?(String)
        bool << indicator.sine.is_a?(Array)
        bool << indicator.lead_sine.is_a?(Array)
        expect(bool.all?{|e| e}).to eq true
    end

    it "can be indicator HT_TRENDMODE" do
      bool = []
      indicator = @stock.indicator(function: "HT_TRENDMODE", interval: "weekly", series_type: "close")
        bool << (indicator.symbol == "MSFT")
        bool << indicator.indicator.is_a?(String)
        bool << indicator.last_refreshed.is_a?(String)
        bool << (indicator.interval == "weekly")
        bool << indicator.series_type.is_a?(String)
        bool << indicator.time_zone.is_a?(String)
        bool << indicator.trendmode.is_a?(Array)
        expect(bool.all?{|e| e}).to eq true
    end

    it "can be indicator HT_DCPERIOD" do
      bool = []
      indicator = @stock.indicator(function: "HT_DCPERIOD", interval: "weekly", series_type: "close")
        bool << (indicator.symbol == "MSFT")
        bool << indicator.indicator.is_a?(String)
        bool << indicator.last_refreshed.is_a?(String)
        bool << (indicator.interval == "weekly")
        bool << indicator.series_type.is_a?(String)
        bool << indicator.time_zone.is_a?(String)
        bool << indicator.dcperiod.is_a?(Array)
        expect(bool.all?{|e| e}).to eq true
    end

    it "can be indicator HT_DCPHASE" do
      bool = []
      indicator = @stock.indicator(function: "HT_DCPHASE", interval: "weekly", series_type: "close")
        bool << (indicator.symbol == "MSFT")
        bool << indicator.indicator.is_a?(String)
        bool << indicator.last_refreshed.is_a?(String)
        bool << (indicator.interval == "weekly")
        bool << indicator.series_type.is_a?(String)
        bool << indicator.time_zone.is_a?(String)
        bool << indicator.ht_dcphase.is_a?(Array)
        expect(bool.all?{|e| e}).to eq true
    end

    it "can be indicator HT_PHASOR" do
      bool = []
      indicator = @stock.indicator(function: "HT_PHASOR", interval: "weekly", series_type: "close")
        bool << (indicator.symbol == "MSFT")
        bool << indicator.indicator.is_a?(String)
        bool << indicator.last_refreshed.is_a?(String)
        bool << (indicator.interval == "weekly")
        bool << indicator.series_type.is_a?(String)
        bool << indicator.time_zone.is_a?(String)
        bool << indicator.quadrature.is_a?(Array)
        bool << indicator.phase.is_a?(Array)
        expect(bool.all?{|e| e}).to eq true
    end
  end
end
