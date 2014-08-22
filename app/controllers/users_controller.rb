class UsersController < ApplicationController
  before_action :require_user, only: :show

  def new
    @user = User.new
  end

  def create
    @user = User.new(post_params)
    inviter = User.find(params['inviter_id']) if params['inviter_id'].present?
    if @user.save
      AppMailer.delay.welcome_to_myflix(@user)
      StripeWrapper::Charge.create(
        :amount => 999,
        :card => params['stripeToken'],
        :description => "Sign up charge for #{@user.email}"
      )
      if inviter
        @user.follow(inviter)
        inviter.follow(@user)
      end
      redirect_to sign_in_path 
    else
      render :new
    end
  end

  def register_with_invitation
    @invitation = Invitation.find_by_token(params[:token])
    if @invitation
      @user = User.new(email: @invitation.invitee_email)
      render :new
    else
      redirect_to expired_token_path
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
