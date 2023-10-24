require "sinatra"
require "sinatra/reloader"
require "http"

get("/") do

  api_url = "https://api.exchangerate.host/list?access_key=#{ENV['EXCHANGE_RATE_KEY']}"

  raw_data = HTTP.get(api_url)
  raw_data_string = raw_data.to_s

  parsed_data = JSON.parse(raw_data_string)

  @symbols = parsed_data["currencies"].keys
  erb(:homepage)
end


get("/:origin") do
  @original_currency = params.fetch("origin")

  api_url = "https://api.exchangerate.host/list?access_key=#{ENV['EXCHANGE_RATE_KEY']}"

  raw_data = HTTP.get(api_url)
  raw_data_string = raw_data.to_s

  parsed_data = JSON.parse(raw_data_string)

  @symbols = parsed_data["currencies"].keys
  erb(:origin)
end

get("/:origin/:convert") do
  @original_currency = params.fetch("origin")
  @destination_currency = params.fetch("convert")

  api_url = "https://api.exchangerate.host/convert?access_key=#{ENV['EXCHANGE_RATE_KEY']}&from=#{@original_currency}&to=#{@destination_currency}&amount=1"

  raw_data = HTTP.get(api_url)
  raw_data_string = raw_data.to_s

  @parsed_data = JSON.parse(raw_data_string)
  @amount = @parsed_data["info"]["quote"].to_s
  erb(:convert)
end
