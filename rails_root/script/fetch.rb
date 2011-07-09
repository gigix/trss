User.find(:all).each do |user|
  begin 
    user.feeds.each do |feed|
      feed.fetch!
    end
  rescue => e
    puts "Error happens when fetching feed ##{feed.id} of user ##{user.id} :"
    puts e.message
    puts e.backtrace.join("\n")
  end
end