class ForgotPasswordsController < ApplicationController

  def create
    user = User.find_by(email: params['email'])
    if user
      set_user_token user
    else
      redirect_to register_path
    end
  end

  private
  def set_user_token user
    user.token = SecureRandom.urlsafe_base64
    user.save(validate: false)
    AppMailer.reset_password(user).deliver
    redirect_to forgot_password_confirmation_path
  end

end
