class FeedsController < ApplicationController
  before_filter :authenticate_user!
  
  def index
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
