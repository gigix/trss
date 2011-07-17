require 'spec_helper'

describe FeedsController do  
  render_views
  
  describe :index do
    it "redirects to signin page if no user signed in" do
      get :index
      response.should redirect_to(new_user_session_path)
    end
    
    it "redirects to oauth page if user is not associated with sina weibo" do
      sign_in create_test_user
      get :index
      response.should redirect_to(oauth_consumer_path(:sina_weibo))
    end
    
    it "renders with empty feed if user already signed in" do
      user = create_test_user
      user.sina_weibo = SinaWeiboToken.create!(:user_id => user.id, :token => "test_token")
      sign_in user
      
      get :index
      response.should be_success
      assigns(:feed).should_not be_nil
    end
  end
  
  describe :create do
    it "redirects to signin page if no user signed in" do
      post :create
      response.should redirect_to(new_user_session_path)
    end
    
    it "creates new feed for current user and redirects" do
      user = create_test_user
      sign_in user 

      rss_url = "http://www.douban.com/feed/people/gigix/interests"
      lambda do
        post :create, :feed => {:url => rss_url}
        response.should redirect_to(feeds_path)
      end.should change(Feed, :count).by(1)
      
      new_feed = Feed.find(:last)
      new_feed.user.should == user
      new_feed.url.should == rss_url
      
      new_feed.title.should_not be_nil
      new_feed.items.should_not be_empty
    end    
  end
end
