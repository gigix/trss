require 'rss'

RSS::Atom::Feed.class_eval do
  def trss_title
    title.content
  end
  
  def mime_type
    "application/atom+xml"
  end
end

RSS::Atom::Feed::Entry.class_eval do
  def trss_title
    title.content
  end
  
  def trss_content
    content.nil? ? summary.content : content.content
  end
  
  def trss_link
    link.href
  end
end

RSS::Rss.class_eval do
  def trss_title
    channel.title
  end
  
  def mime_type
    "application/rss+xml"
  end
end

RSS::Rss::Channel::Item.class_eval do
  alias_method :trss_title, :title
  alias_method :trss_content, :description
  alias_method :trss_link, :link
end