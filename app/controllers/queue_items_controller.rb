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
    reorder_queue_items
    redirect_to my_queue_path
  end

  def update
    begin
      ActiveRecord::Base.transaction do
        queue_items = current_user.queue_items
        queue_items.each_with_index do |queue_item, index|
          queue_item.position = params[:queue_items]['position'][index]
          queue_item.save!
        end
      end
    rescue ActiveRecord::RecordInvalid
      flash[:danger] = 'Please check the position number you put in'
    end

    reorder_queue_items
    redirect_to my_queue_path
  end

  def queue_item_exsited?(video)
    current_user.queue_items.map(&:video).include?(video)
  end

  def reorder_queue_items
    current_user.queue_items.each_with_index do |queue_item, index|
      queue_item.update_attributes(position: index+1)
    end
  end

end
