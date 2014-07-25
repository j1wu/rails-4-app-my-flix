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

  def queue_item_exsited?(video)
    QueueItem.all.map(&:video).include?(video)
  end

end