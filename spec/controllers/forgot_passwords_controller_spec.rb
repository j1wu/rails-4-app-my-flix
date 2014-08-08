require 'spec_helper'

describe ForgotPasswordsController do

  describe 'POST create' do
    let!(:bob) { Fabricate(:user, email: 'bob@example.com') }
    after { ActionMailer::Base.deliveries.clear }
    context 'with valid input' do
      it 'redirects user to confirm password reset page' do
        post :create, email: 'bob@example.com'
        expect(response).to redirect_to forgot_password_confirmation_path
      end
      it 'sets the random token value for user' do
        post :create, email: 'bob@example.com'
        expect(User.first.token).not_to be_nil
      end
      it 'sends out email' do
        post :create, email: 'bob@example.com'
        expect(ActionMailer::Base.deliveries).not_to be_empty
      end
      it 'sends out email to the right receipant' do
        post :create, email: 'bob@example.com'
        expect(ActionMailer::Base.deliveries.last.to).to eq([bob.email])
      end
      it 'sends out email with the reset password url embeded' do
        post :create, email: 'bob@example.com'
        expect(ActionMailer::Base.deliveries.last.body).to include('reset_passwords/')
      end
    end

    context 'with invalid input' do
      let!(:steve) { Fabricate(:user, email: 'steve@example.com') }
      after { ActionMailer::Base.deliveries.clear }
      it 'redirects user to register page if no user with that email found' do
        post :create, email: 'x@example.com'
        expect(response).to redirect_to register_path 
      end
      it 'does not sets random token value for user' do
        post :create, email: ''
        expect(User.first.token).to be_nil
      end
      it 'does not send out email' do
        post :create, email: 'x@example.com'
        expect(ActionMailer::Base.deliveries).to be_empty
      end
    end
  end

end
