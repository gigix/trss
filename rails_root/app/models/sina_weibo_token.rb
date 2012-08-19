class SinaWeiboToken < ConsumerToken
  def add_status!(status)
    client.post("http://api.weibo.com/2/statuses/update.json", {:status => status})
  end
end