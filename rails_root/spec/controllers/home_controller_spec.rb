require 'spec_helper'

describe HomeController do
  render_views
  
  describe :index do
    it "renders with latest 50 items" do
      user_1 = create_test_user
      user_2 = create_test_user
      
      user_1.feeds.create!(:url => "http://test.com/path1")
      user_2.feeds.create!(:url => "http://test.com/path2")
      
      50.times do |i|
        user_1.feeds.first.feed_items.create!(:title => "feed item 1-#{i}", :content => "Feed item 1-#{i}")
        user_2.feeds.first.feed_items.create!(:title => "feed item 2-#{i}", :content => "Feed item 2-#{i}")
      end
      
      get :index
      response.should be_success
      assigns(:feed_items).should have(50).items
    end
  end
end
