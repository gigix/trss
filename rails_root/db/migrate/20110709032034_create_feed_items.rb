class CreateFeedItems < ActiveRecord::Migration
  def self.up
    create_table :feed_items do |t|
      t.references :feed
      
      t.string :title
      t.string :link
      t.text :content

      t.datetime :edited_at

      t.timestamps
    end
  end

  def self.down
    drop_table :feed_items
  end
end
