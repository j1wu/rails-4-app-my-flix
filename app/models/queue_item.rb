class QueueItem < ActiveRecord::Base
  belongs_to :user
  belongs_to :video

  validates_numericality_of :position, {only_integer: true}

  def rating
    review.rating if review
  end
  
  def rating=(new_rating)
    if review
      review.rating = new_rating
      review.save(validate: false)
    else
      review = video.reviews.new(rating: new_rating, user_id: user.id, video_id: video.id)
      review.save(validate: false)
    end 
  end

  private
  def review
    @review ||= Review.where(user_id: user.id, video_id: video.id).first
  end
end
