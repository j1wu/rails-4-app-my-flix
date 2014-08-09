class UsersController < ApplicationController
  before_action :require_user, only: :show

  def new
    @user = User.new
  end

  def create
    @user = User.new(post_params)
    if @user.save
      if (params['user']['inviter_id'])
        Relationship.create(follower_id: @user.id, leader_id: params['user']['inviter_id'])
        Relationship.create(follower_id: params['user']['inviter_id'], leader_id: @user.id)
      else
      end
      AppMailer.delay.welcome_to_myflix(@user)
      redirect_to sign_in_path 
    else
      render :new
    end
  end

  def show
    @user = User.find(params[:id])
  end

  private

  def post_params
    params.require(:user).permit(:email, :password, :full_name)
  end

end
