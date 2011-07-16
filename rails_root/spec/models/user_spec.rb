require 'spec_helper'

describe User do
  describe :create do
    it 'creates valid user' do
      create_test_user.id.should_not be_nil
    end
  end
  
  describe :sync! do
    it 'syncs feed items to micro blog' do
      weibo = SinaWeiboToken.new
      weibo.should_receive(:post).with("http://api.t.sina.com.cn/statuses/update.json", {:status => "something"})
      
      user = create_test_user
      user.sina_weibo = weibo
      feed = user.feeds.create!
      feed.feed_items.create!(:title => "something")
      
      user.sync!
    end
  end
end
