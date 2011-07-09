# Load the rails application
require File.expand_path('../application', __FILE__)

# Initialize the rails application
RailsRoot::Application.initialize!

# Load custom enhancements
Dir["#{Rails.root}/lib/enhancements/*.rb"].each do |rb_file|
  require rb_file
end