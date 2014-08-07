class UsersController < ApplicationController
  before_action :require_user, only: :show

  def new
    @user = User.new
  end

  def create
    @user = User.new(post_params)
    if @user.save
      AppMailer.welcome_to_myflix(@user).deliver
      redirect_to sign_in_path 
    else
      render :new
    end
  end

  def show
    @user = User.find(params[:id])
  end

  def reset_password
    user = User.find_by(email: params['email'])
    if user
      set_user_token user
    else
      redirect_to register_path
    end
  end

  def confirm_password_reset
  end

  def update_password
    user = User.find_by(token: params['token'])
    if user
      @user = user
      flash.now[:info] = 'Please enter the new password'
    else
      redirect_to register_path
    end
  end

  def save_password
    if params[:password] == ''
      render 'update_password'
    else
      user = User.find(params[:user_id])
      user.password = params[:password]
      user.token = nil
      user.save
      flash[:info] = 'Password had been reset'
      redirect_to sign_in_path
    end
  end

  private

  def set_user_token user
    user.token = SecureRandom.urlsafe_base64
    user.save(validate: false)
    AppMailer.reset_password(user).deliver
    redirect_to confirm_password_reset_path
  end

  def post_params
    params.require(:user).permit(:email, :password, :full_name)
  end

end
