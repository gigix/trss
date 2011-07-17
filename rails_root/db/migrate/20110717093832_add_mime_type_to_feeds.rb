class AddMimeTypeToFeeds < ActiveRecord::Migration
  def self.up
    add_column :feeds, :mime_type, :string
  end

  def self.down
    drop_column :feeds, :mime_type
  end
end
