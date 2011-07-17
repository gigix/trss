User.find(:all).each do |user|
  begin
    user.sync!
  rescue => e
    puts "Error happens when syncing feed items of user ##{user.id} :"
    puts e.message
    puts e.backtrace.join("\n")
  end
end