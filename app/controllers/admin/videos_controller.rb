class Admin::VideosController < ApplicationController
  before_action :require_user, :require_admin

  def new
    @video = Video.new
  end

  def create
    @video = Video.new(post_params)
    if @video.save
      flash[:success] = 'Video added'
      redirect_to admin_add_video_path
    else
      render :new
    end
  end

  private
  def post_params
    params.require(:video).permit(:title, :description, :category_id, :small_cover, :large_cover)
  end

end
