require 'rss'
require 'open-uri'

####### Parsing Atom 

content = open("#{File.dirname(__FILE__)}/spec/fixtures/sample.atom"){|f| f.read}
rss = RSS::Parser.parse(content, false)

puts rss.title
puts rss.entries.size
puts rss.items.size

# puts rss.entries[0].id
# puts rss.entries[0].title.content
puts rss.entries[0].content.content
puts rss.entries[0].link
# puts rss.entries[0].updated.inspect



######### Parsing RSS

content = open("#{File.dirname(__FILE__)}/spec/fixtures/sample.rss"){|f| f.read}
rss = RSS::Parser.parse(content, false)

puts rss.channel.title
puts rss.items.size
puts rss.items[0].title
puts rss.items[0].description
puts rss.items[0].link