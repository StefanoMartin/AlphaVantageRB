require "httparty"

module HelperFunctions
  def check_argument(list, value)
    unless list.include? value
      raise ArgumentError, "Only #{list.join(", ")} are supported"
    end
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
