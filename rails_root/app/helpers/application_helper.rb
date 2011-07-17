module ApplicationHelper
  def title(text)
    content_for :title, text
  end
  
  def rss(feed)
    content_for :alternate_link, 
      %Q(<link rel="alternate" href="#{feed.url}" type="#{feed.mime_type}" title="#{feed.title}" />).html_safe
  end
end
