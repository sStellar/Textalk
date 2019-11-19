require 'net/http'
require 'openssl'
require 'json'

class Twapi
  def initialize
    @uri = URI("https://shop.textalk.se/backend/jsonrpc/v1/?webshop=92323&auth=YXV0aDpWEMLwfmEfSpy5IztDVuyGa7MvXWzGpqI7d8fKllP/04QH&session=d1920be29bf84588940e7cca9309fe63")

  end

  def sendToApi(payload)
    req = Net::HTTP::Post.new(@uri, 'Content-Type' => 'application/json')
    req.body = payload.to_json
    http = Net::HTTP.new(@uri.hostname, @uri.port)
    http.use_ssl = true
    puts req.body
    result = http.request(req)
    return result.body
  end

  def loginApi
    payload = {
      "jsonrpc" => "2.0",
      "method" => "Admin.login",
      "id" => 1,
      "params" => ["peter.alnas@elev.ga.ntig.se", "peter1218"]
    }.to_json
    token = sendToApi(payload)
    puts token
    return token
  end
end

=begin

payloadA = {
  "jsonrpc" => "2.0",
  "id" => 1,
  "method" => "Article.count",
  "params" => [true, true]
    #"search" => {
    #  "term" => "dude",
    #  "relevance" => 100
    #}
}.to_json


payloadB = {
  "jsonrpc" => "2.0",
  "id" => 1,
  "method" => "Article.get",
  "params" => [true, true]#172139951, ["hidden", "name", "weight"]]
}.to_json
=end


#r = Twapi.new

#login = r.loginApi

#p r.sendToApi(payloadB)
