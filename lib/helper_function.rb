require "httparty"

module HelperFunctions
  def check_argument(list, value)
    unless list.include? value
      raise ArgumentError, "Only #{list.join(", ")} are supported"
    end
  end

  def return_matype(val, val_string)
    check_argument(["0", "1", "2", "3", "4", "5", "6", "7", "8", "SMA", "EMA", "WMA", "DEMA", "TEMA", "TRIMA", "T3", "KAMA", "MAMA"], val)
    hash = {"SMA" => "0", "EMA" => "1", "WMA" => "2", "DEMA" => "3",
      "TEMA" => "4", "TRIMA" => "5", "T3" => "6", "KAMA" => "7", "MAMA" => "8"}
    val = hash[val] unless hash[val].nil?
    return "&#{val_string}=#{val}"
  end

  def return_int_val(val, val_string, type="integer")
    value = case type
    when "integer"
      val.to_i
    when "float"
      val.to_f
    end
    raise "Error: #{val_string} is not a correct positive #{type}" if value.to_s != val || value <= 0
    return "&#{val_string}=#{val}"
  end

  def request(url)
    base_uri = "https://www.alphavantage.co"
    begin
      response = HTTParty.get("#{base_uri}/#{url}")
    rescue Exception => e
      raise "HTTParty ERROR: #{e.message}"
    end
    data = response.body
    begin
      data = JSON.parse(data)
    rescue Exception => e
      raise "JSON error: #{e.message}"
    end
    unless data["Error Message"].nil?
      raise "ALPHAVANTAGE ERROR: #{data["Error Message"]}"
    end
    return data
  end

  def download(url, file)
    begin
      uri = URI.parse("https://www.alphavantage.co/#{url}&datatype=csv")
      uri.open{|csv| IO.copy_stream(csv, file)}

    rescue Exception => e
      raise "CSV Error: No csv created #{e.message}"
    end
    return "CSV saved in #{file}"
  end
end
