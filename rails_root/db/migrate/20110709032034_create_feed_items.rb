class CreateFeedItems < ActiveRecord::Migration
  def self.up
    create_table :feed_items do |t|
      t.references :feed
      
      

      t.timestamps
    end
  end

  def self.down
    drop_table :feed_items
  end
end
