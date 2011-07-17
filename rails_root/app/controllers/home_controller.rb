class HomeController < ApplicationController
  def index
    @feed_items = FeedItem.find(:all, :limit => 50, :order => "created_at DESC")
  end
end
