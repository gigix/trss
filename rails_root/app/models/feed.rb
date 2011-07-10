require 'rss'
require 'open-uri'

class Feed < ActiveRecord::Base
  belongs_to :user
  has_many :feed_items
  
  alias_method :items, :feed_items
  
  validate :duplication_is_not_allowed
  
  def fetch!
    content = fetch_content
    raw_feed = RSS::Parser.parse(content, false)
    update_attribute(:title, raw_feed.trss_title)
    raw_feed.items.each do |item|
      next if already_fetched?(item)
      feed_items.create!(:title => item.trss_title, :content => item.trss_content, :link => item.trss_link)
    end
  end
  
  private
  def fetch_content
    open(url){|resource| resource.read}
  end
  
  def already_fetched?(raw_item)
    not feed_items.find_by_link(raw_item.trss_link).nil?
  end
  
  def duplication_is_not_allowed
    errors.add(:url, "Duplicated") if Feed.find_by_user_id_and_url(user, self.url)
  end
end
