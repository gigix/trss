class SinaWeiboToken < ConsumerToken
  def add_status!(status)
    client.post("http://api.t.sina.com.cn/statuses/update.json", {:status => status})
  end
end