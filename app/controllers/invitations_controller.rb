class InvitationsController < ApplicationController
  before_action :require_user

  def new
    @invitation = Invitation.new
  end

  def create
    @invitation = Invitation.new(post_params)
    @invitation.inviter_id = current_user.id
    if @invitation.save
      AppMailer.invite(@invitation).deliver
      flash[:success] = "Invitation sent"
      redirect_to invitation_path 
    else
      flash[:danger] = "Information missing"
      redirect_to invitation_path
    end
  end

  private
  def post_params
    params.require(:invitation).permit(:inviter_id, :invitee_name, :invitee_email, :message) 
  end

end
