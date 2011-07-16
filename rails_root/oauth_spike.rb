consumer = OAuth::Consumer.new("40496012","90aff4684b1cf7688c78fb3114284abc", {
  :site => "http://api.t.sina.com.cn",
  :request_token_path => "/oauth/request_token",
  :access_token_path => "/oauth/access_token",
  :authorize_path => "/oauth/authorize"
})

request_token = consumer.get_request_token

puts request_token.authorize_url

verify_code = gets

access_token = request_token.get_access_token(:oauth_verifier => verify_code.strip)

puts access_token.inspect

options = {:status => "hi"}
access_token.post("http://api.t.sina.com.cn/statuses/update.json", options)