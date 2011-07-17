require 'spec_helper'

describe User do
  describe :create do
    it 'creates valid user' do
      create_test_user.id.should_not be_nil
    end
  end
  
  describe :active_feeds do
    it 'includes only active feeds belongs to this user' do
      user = create_test_user
      active_feed = user.feeds.create!(:url => "http://test1.com/path")
      inactive_feed = user.feeds.create!(:url => "http://test2.com/path")
      inactive_feed.inactivate!
      
      user.active_feeds.should == [active_feed]
    end
  end
  
  describe :sync! do
    before(:each) do
      @weibo = SinaWeiboToken.new
      @access_token = mock(:access_token)
      @weibo.stub!(:client).and_return(@access_token)
      
      @user = create_test_user
      @user.sina_weibo = @weibo
    end
    
    it 'syncs feed items to micro blog' do
      feed = @user.feeds.create!
      feed.feed_items.create!(:title => "something", :link => "http://some.site/path")
      @access_token.should_receive(:post).with("http://api.t.sina.com.cn/statuses/update.json", {:status => "something <http://some.site/path>"})
      
      @user.sync!
    end
    
    it 'does not sync feed items which were synced already' do
      feed = @user.feeds.create!
      feed.feed_items.create!(:title => "something", :link => "http://some.site/path")
      @access_token.should_receive(:post).with("http://api.t.sina.com.cn/statuses/update.json", {:status => "something <http://some.site/path>"})
      
      @user.sync!
      @user.sync!
    end
    
    it 'does not sync feed items in inactive feeds' do
      feed = @user.feeds.create!
      feed.feed_items.create!(:title => "something", :link => "http://some.site/path")
      inactive_feed = @user.feeds.create!(:url => "http://inactive.feed")
      inactive_feed.inactivate!
      inactive_feed.feed_items.create!(:title => "other thing", :link => "http://some.site/path1")
      @access_token.should_receive(:post).with("http://api.t.sina.com.cn/statuses/update.json", {:status => "something <http://some.site/path>"})
      
      @user.sync!
    end
  end
end
