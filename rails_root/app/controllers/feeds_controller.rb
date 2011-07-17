class FeedsController < ApplicationController
  before_filter :authenticate_user!
  
  def index
    redirect_to oauth_consumer_path(:sina_weibo) and return if current_user.sina_weibo.nil?
    @feed = Feed.new
  end
  
  def create
    new_feed = current_user.feeds.create!(params[:feed])
    new_feed.fetch!
  rescue
  ensure
    redirect_to feeds_path
  end
end
