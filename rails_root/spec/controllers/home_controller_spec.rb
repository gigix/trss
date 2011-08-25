require 'spec_helper'

describe HomeController do
  render_views
  
  describe :index do
    it "renders with latest 50 items" do
      user_1 = create_test_user
      user_2 = create_test_user
      
      user_1.feeds.create!(:url => "http://test.com/path1")
      user_2.feeds.create!(:url => "http://test.com/path2")
      
      30.times do |i|
        user_1.feeds.first.feed_items.create!(:title => "feed item 1-#{i}", :content => "Feed item 1-#{i}")
        user_2.feeds.first.feed_items.create!(:title => "feed item 2-#{i}", :content => "Feed item 2-#{i}")
      end
      
      get :index
      response.should be_success
      assigns(:feed_items).should have(50).items
      assigns(:feed_items).first.title.should == "feed item 2-29"
      assigns(:feed_items).last.title.should == "feed item 1-5"
    end
    
    it "be tolerant even if feed has a nil content" do
      user = create_test_user
      feed = user.feeds.create!(:url => "http://test.com/path")
      feed.feed_items.create!(:title => "feed without content")
      
      get :index
      response.should be_success
    end
  end
end
