class User < ActiveRecord::Base
  has_many :reviews
  has_many :queue_items, -> { order('position')}

  has_secure_password validations: false

  validates_presence_of :email, :password, :full_name
  validates :email, uniqueness: true

  def normailize_queue_item_positions
    self.queue_items.each_with_index do |queue_item, index|
      queue_item.update_attributes(position: index+1)
    end
  end
  
  def video_exists_in_queue? video 
    self.queue_items.map(&:video).include? video 
  end

  def reviews_with_content
    self.reviews.reject { |review| review.content.nil? }
  end

end
