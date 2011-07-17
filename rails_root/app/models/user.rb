class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :token_authenticatable, :encryptable, :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  # Setup accessible (or protected) attributes for your model
  attr_accessible :email, :password, :password_confirmation, :remember_me
  
  has_one  :sina_weibo, :class_name => "SinaWeiboToken", :dependent => :destroy
  
  has_many :feeds
  has_many :feed_items, :through => :feeds
  
  def sync!
    feed_items.find_all_by_synced_at(nil).each do |item|
      sina_weibo.add_status!(item.to_t)
      item.update_attribute(:synced_at, Time.now)
    end
  end
end
