class ResetPasswordsController < ApplicationController

  def show
    user = User.find_by(token: params['id'])
    if user
      @user = user
      flash.now[:info] = 'Please enter the new password'
    else
      redirect_to expired_token_path
    end
  end

  def create
    user = User.find(params[:user_id])
    user.password = params[:password]
    user.token = nil
    user.save
    flash[:info] = 'Password had been reset'
    redirect_to sign_in_path
  end

end
