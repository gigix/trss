class FeedsController < ApplicationController
  before_filter :authenticate_user!
  
  def index
    @feed = Feed.new
  end
  
  def create
    current_user.feeds.create!(params[:feed])
    redirect_to feeds_path
  end
end
