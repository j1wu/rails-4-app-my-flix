class ReviewsController < ApplicationController
  before_action :require_user

  def create
    video = Video.find(params[:video_id])
    review = video.reviews.build(post_params.merge!(user: current_user))
    if review.save
      redirect_to video_path(video)
    else
      # it 'sets @video'
      # to ensure @video is still there after rendering, and also to eliminate the phatom review record issue
      @video = video.reload
      @review = review
      flash.now[:danger] = 'Rating or content cannot be blank'
      render 'videos/show'
    end
  end

  private
  def post_params
    params.require(:review).permit(:content, :rating)
  end

end