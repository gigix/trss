class AddStatusToFeeds < ActiveRecord::Migration
  def self.up
    add_column :feeds, :status, :string, :default => Feed::Status::ACTIVE
  end

  def self.down
    drop_column :feeds, :status
  end
end
