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
    
    it "activates existing feed" do
      user = create_test_user
      sign_in user 
      
      rss_url = "http://www.douban.com/feed/people/gigix/interests"
      feed = user.feeds.create!(:url => rss_url)
      feed.inactivate!
      
      lambda do
        post :create, :feed => {:url => rss_url}
        response.should redirect_to(feeds_path)
      end.should_not change(Feed, :count)
      
      feed.reload.should be_active
    end  
  end
  
  describe :destroy do
    it "redirects to signin page if no user signed in" do
      delete :destroy, :id => 1
      response.should redirect_to(new_user_session_path)
    end
    
    it "redirects to signin page if user tries to destroy a feed belongs to other" do
      first_user = create_test_user
      feed = first_user.feeds.create!
      
      second_user = create_test_user
      sign_in second_user
      
      delete :destroy, :id => feed.id
      response.should redirect_to(new_user_session_path)
    end
    
    it "sets feed status to 'inactive'" do
      user = create_test_user
      sign_in user
      feed = user.feeds.create!
      feed.should be_active
      
      delete :destroy, :id => feed.id

      response.should redirect_to(root_path)
      feed.reload.should_not be_active
    end
  end
  
  describe :show do
    it "renders with specified feed" do
      feed = create_test_user.feeds.create(:url => "http://www.douban.com/feed/people/gigix/interests")
      get :show, :id => feed.id

      response.should be_success
      assigns(:feed).should == feed
    end
  end
end
