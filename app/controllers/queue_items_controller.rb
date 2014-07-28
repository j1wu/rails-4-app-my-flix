class QueueItemsController < ApplicationController
  before_action :require_user

  def index
    @queue_items = current_user.queue_items
  end

  def create
    video = Video.find_by(id: params[:id])
    unless queue_item_exsited?(video)
      QueueItem.create(video: video, user: current_user, position: QueueItem.ids.count + 1)
    else
      flash[:info] = 'Video already exsited in queue'
    end
    redirect_to my_queue_path
  end

  def destroy
    queue_item = QueueItem.find_by(id: params['id'])
    queue_item.delete
    current_user.normailize_queue_item_positions
    redirect_to my_queue_path
  end

  def update_queue
    begin
      update_queue_items
      current_user.normailize_queue_item_positions
    rescue ActiveRecord::RecordInvalid
      flash[:danger] = 'Invalid position numbers.'
    end
    redirect_to my_queue_path
  end

  private

  def queue_item_exsited?(video)
    current_user.queue_items.map(&:video).include?(video)
  end

  def update_queue_items
    ActiveRecord::Base.transaction do
      params[:queue_items].each do |queue_item_data|
        queue_item = QueueItem.find(queue_item_data['id'])

        video = queue_item.video
        if video.reviews.count > 0
          reviews = queue_item.video.reviews.where(user: current_user) 
          reviews.each do |review|
            review.rating = queue_item_data['rating']
            review.save(validate: false)
          end
        else
          review = video.reviews.new(rating: queue_item_data['rating'], user_id: current_user.id)
          review.save(validate: false) 
        end

        queue_item.update_attributes!(position: queue_item_data['position']) if queue_item.user == current_user
      end
    end
  end

end
