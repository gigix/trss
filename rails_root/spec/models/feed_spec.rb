require 'spec_helper'

describe Feed do
  describe :create! do
    it "does not allow duplication under same user" do
      user = create_test_user
      user.feeds.create!(:url => "http://www.douban.com/feed/people/gigix/interests")
      
      lambda do
        user.feeds.create!(:url => "http://www.douban.com/feed/people/gigix/interests")
      end.should raise_error
    end
    
    it "does not allow empty url" do
      user = create_test_user
      lambda do
        user.feeds.create!(:url => " ")      
      end.should raise_error
    end
    
    it "handles html page with alternate rss feed" do
      feed = Feed.create!(:url => "http://www.thoughtworks.com/blogs")
      feed.fetch!

      feed.feed_items.size.should > 0
      feed.url.should == "http://www.thoughtworks.com/blogs/rss/current"
    end
  end
  
  describe :fetch! do
    it "actually grabs rss" do
      feed = Feed.create!(:url => "http://www.douban.com/feed/people/gigix/interests")
      feed.fetch!
      feed.feed_items.size.should > 0
    end
    
    it "parses grabbed atom and stores new items" do
      rss_content = File.open(File.join(Rails.root, "spec", "fixtures", "sample.atom")){|f| f.read}
      feed = Feed.create!(:url => "http://test.com/sample.atom")
      feed.should_receive(:fetch_content).and_return(rss_content)
      
      feed.fetch!
      feed.reload
      
      feed.title.should == "Google Buzz Public Activities Feed for Jeff Xiong"
      feed.feed_items.size.should == 20

      first_item = feed.feed_items.last
      first_item.title.should == "百年老店的基因"
      first_item.content.should == "百年老店的基因"
      first_item.link.should == "https://profiles.google.com/gigix1980/posts/DtnJbjFyGL1"
    end

    it "parses grabbed rss and stores new items" do
      rss_content = File.open(File.join(Rails.root, "spec", "fixtures", "sample.rss")){|f| f.read}
      feed = Feed.create!(:url => "http://test.com/sample.rss")
      feed.should_receive(:fetch_content).and_return(rss_content)
      
      feed.fetch!
      feed.reload
      
      feed.title.should == "透明 的收藏"
      feed.feed_items.size.should == 10

      first_item = feed.feed_items.last
      first_item.title.should == "想看速度与激情5"
      first_item.content.should == %Q(<table><tr><td width="80px"><a href="http://movie.douban.com/subject/4286017/" title="Fast Five"><img src="http://img3.douban.com/spic/s4672723.jpg" alt="Fast Five"></a></td><td></td></tr></table>)
      first_item.link.should == "http://movie.douban.com/subject/4286017/"
    end
    
    it "does not duplicate feed items" do
      rss_content = File.open(File.join(Rails.root, "spec", "fixtures", "sample.rss")){|f| f.read}
      feed = Feed.create!(:url => "http://test.com/sample.rss")
      feed.stub!(:fetch_content).and_return(rss_content)
      
      feed.fetch!
      feed.fetch!
      
      feed.feed_items.size.should == 10
    end
  end
end
