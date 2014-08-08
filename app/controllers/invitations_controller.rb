class InvitationsController < ApplicationController
  before_action :require_user

  def create
    if params['full_name'].blank? or params['email'].blank?
      flash[:danger] = 'Missing name or email'
      redirect_to invitation_path
    else
      user = User.new
      user.full_name = params['full_name']
      user.email = params['email']
      message = params['message']
      AppMailer.invite(user, message).deliver
      flash[:success] = 'Invitation sent!'
      redirect_to invitation_path
    end
  end

end
