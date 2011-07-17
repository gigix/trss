class FeedsController < ApplicationController
  before_filter :authenticate_user!
  
  def index
    redirect_to oauth_consumer_path(:sina_weibo) and return unless current_user.sina_weibo
    @feed = Feed.new
  end
  
  def create
    existing_feed = current_user.feeds.find_by_url(params[:feed][:url])
    existing_feed.activate! and return if existing_feed
    
    new_feed = current_user.feeds.create!(params[:feed])
    new_feed.fetch!
  rescue
  ensure
    redirect_to feeds_path
  end
  
  def destroy
    feed = current_user.feeds.find_by_id(params[:id])
    redirect_to new_user_session_path and return unless feed
    
    feed.inactivate!
    redirect_to root_path
  end
end
