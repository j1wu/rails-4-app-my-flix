class Video < ActiveRecord::Base
  belongs_to :category
  has_many :reviews, -> { order('created_at DESC') }
  has_many :queue_items

  validates_presence_of :title, :description

  def self.search_by_title(search_term)
    return [] if search_term.blank?
    where("title LIKE ?", "%#{search_term}%").order('title')
  end

  def average_rating
    return 'Not Yet Rated' if self.reviews.empty?
    self.reviews.average(:rating)
  end

  def update_rating new_rating, user
    unless self.reviews.empty?
      reviews = self.reviews.where(user: user) 
      reviews.each do |review|
        review.rating = new_rating
        review.save(validate: false)
      end
    else
      review = self.reviews.new(rating: new_rating, user_id: user.id)
      review.save(validate: false) 
    end
  end

end
