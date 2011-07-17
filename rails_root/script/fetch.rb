User.find(:all).each do |user|
    user.active_feeds.each do |feed|
      begin 
        feed.fetch!
      rescue => e
        puts "Error happens when fetching feed ##{feed.id} of user ##{user.id} :"
        puts e.message
        puts e.backtrace.join("\n")
      end
    end
end