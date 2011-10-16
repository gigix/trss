require 'rss'
require 'open-uri'
require 'hpricot'

class Feed < ActiveRecord::Base
  belongs_to :user
  has_many :feed_items, :order => "created_at DESC"
  
  alias_method :items, :feed_items
  
  validate :url_duplication_is_not_allowed, :empty_url_is_not_allowed
  
  def fetch!
    content = fetch_content
    content.gsub!("date.Taken", "dateTaken") # This is to fix a known issue in Flickr feed
    raw_feed = parse_rss_content(content)
    
    #TODO: should use update_attributes once, instead of update_attribute multiple times
    update_attribute(:title, raw_feed.trss_title)
    update_attribute(:mime_type, raw_feed.mime_type)
    
    raw_feed.items.each do |item|
      next if already_fetched?(item)
      feed_items.create!(:title => item.trss_title, :content => item.trss_content, :link => item.trss_link)
    end
    
    activate!
  end

  class Status
    ACTIVE = 'active'
    INACTIVE = 'inactive'
  end
  
  def active?
    status == Status::ACTIVE
  end
  
  def inactivate!
    update_attribute(:status, Status::INACTIVE)
  end
  
  def activate!
    update_attribute(:status, Status::ACTIVE)
  end
  
  private
  def parse_rss_content(content)
    RSS::Parser.parse(content, false)
  rescue
    doc = Hpricot(content)
    rss_uri = URI::join(url, doc.at("//link[@rel='alternate']")[:href])
    update_attribute(:url, rss_uri.to_s)
    RSS::Parser.parse(fetch_content, false)
  end
  
  def fetch_content
    open(url){|resource| resource.read}
  end
  
  def already_fetched?(raw_item)
    not feed_items.find_by_link(raw_item.trss_link).nil?
  end
  
  def url_duplication_is_not_allowed
    errors.add(:url, "Duplicated") if Feed.find_by_user_id_and_url(user, self.url)
  end  
  
  def empty_url_is_not_allowed
    errors.add(:url, "Empty") if self.url.strip.empty?
  end
end
