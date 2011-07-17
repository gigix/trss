module FeedsHelper
  def render_feed_title(feed)
    title = link_to((feed.title || "<未抓取>") + " (共#{feed.items.count}条)", feed.url)
    link_to_source = link_to("查看原文", feed.url)
    link_to_destroy = link_to("删除", feed_path(feed), {:confirm => "停止同步此频道，是否确定？", :method => :delete})
    title + " | " + link_to_source + " | " + link_to_destroy
  end
end
