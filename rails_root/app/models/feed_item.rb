class FeedItem < ActiveRecord::Base
  belongs_to :feed
  
  def to_t
    "#{title} <#{link} >"
  end
end
