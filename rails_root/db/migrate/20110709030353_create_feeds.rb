class CreateFeeds < ActiveRecord::Migration
  def self.up
    create_table :feeds do |t|
      t.references :user
      
      t.string :name
      t.string :url

      t.timestamps
    end
  end

  def self.down
    drop_table :feeds
  end
end
