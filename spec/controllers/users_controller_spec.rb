require 'spec_helper'

describe UsersController do 

  describe 'POST create' do
    context 'valid input' do
      before do
        post :create, user: Fabricate.attributes_for(:user)
      end
      it 'creates user record' do
        expect(User.count).to eq(1)
      end
      it 'redirects user to sign in path' do
        expect(response).to redirect_to sign_in_path
      end
    end

    context 'email sending' do
      before do
        post :create, user: {email: 'john@example.com', password: '123', full_name: 'john smith'}
      end
      it 'sends out email' do
        expect(ActionMailer::Base.deliveries).not_to be_empty 
      end
      it 'sends out the email to the right person' do
        expect(ActionMailer::Base.deliveries.last.to).to eq(['john@example.com'])
      end
      it 'sends out the email with right content' do
        expect(ActionMailer::Base.deliveries.last.subject).to eq('Welcome to MyFliX!')
      end
    end

    context 'email sending with invalid input' do
      before do
        ActionMailer::Base.deliveries.clear 
      end
      it 'does not send out email with invalid input' do
        post :create, user: {email: 'john@example.com', password: '123', full_name: ''}
        expect(ActionMailer::Base.deliveries).to be_empty 
      end
    end

    context 'invalid input' do
      before do
        post :create, user: {email: 'john@example.com', password: '', full_name: 'john smith'}
      end
      it 'does not create user record' do
        expect(User.count).to eq(0)
      end
      it 'renders new template' do
        expect(response).to render_template :new
      end
    end
  end

  describe 'GET show' do
    context 'with authenticated user' do
      before do
        set_current_user
      end
      it 'renders user/show template' do
        get :show, id: current_user.id
        expect(response).to render_template :show
      end
      it 'sets @user instance variable' do
        get :show, id: current_user.id
        expect(assigns(:user)).to eq(current_user)
      end
    end
    context 'with unauthenticated user' do
      it 'redirects user to sign in page' do
        get :show, id: Fabricate(:user).id
        expect(response).to redirect_to sign_in_path
      end
    end
  end

  describe 'POST reset_password' do
    let!(:bob) { Fabricate(:user, email: 'bob@example.com') }
    after { ActionMailer::Base.deliveries.clear }
    context 'with valid input' do
      it 'redirects user to confirm password reset page' do
        post :reset_password, email: 'bob@example.com'
        expect(response).to redirect_to confirm_password_reset_path 
      end
      it 'sets the random token value for user' do
        post :reset_password, email: 'bob@example.com'
        expect(User.first.token).not_to be_nil
      end
      it 'sends out email' do
        post :reset_password, email: 'bob@example.com'
        expect(ActionMailer::Base.deliveries).not_to be_empty
      end
      it 'sends out email to the right receipant' do
        post :reset_password, email: 'bob@example.com'
        expect(ActionMailer::Base.deliveries.last.to).to eq([bob.email])
      end
      it 'sends out email with the reset password url embeded' do
        post :reset_password, email: 'bob@example.com'
        expect(ActionMailer::Base.deliveries.last.body).to include('update_password/')
      end
    end

    context 'with invalid input' do
      let!(:steve) { Fabricate(:user, email: 'steve@example.com') }
      after { ActionMailer::Base.deliveries.clear }
      it 'redirects user to register page if no user with that email found' do
        post :reset_password, email: 'x@example.com'
        expect(response).to redirect_to register_path 
      end
      it 'does not sets random token value for user' do
        post :reset_password, email: ''
        expect(User.first.token).to be_nil
      end
      it 'does not send out email' do
        post :reset_password, email: 'x@example.com'
        expect(ActionMailer::Base.deliveries).to be_empty
      end
    end
  end

  describe 'GET update_password' do
    let!(:jay) { Fabricate(:user, email: 'jay@example.com', password: '123', token: 'abc') }
    it 'sets flash message with valid token' do
      get :update_password, token: 'abc'
      expect(flash[:info]).to eq('Please enter the new password')
    end
    it 'sets @user instance variable' do
      get :update_password, token: 'abc'
      expect(assigns(:user)).to eq(jay)
    end
    it 'redirects user to register page with invalid token' do
      get :update_password, token: 'efg'
      expect(response).to redirect_to register_path
    end
  end

  describe 'POST save_password' do
    let!(:jay) { Fabricate(:user, email: 'jay@example.com', password: '123', token: 'abc') }
    context 'with valid input' do
      it 'redirects user to sign in page' do
        post :save_password, user_id: jay.id, password: '456'
        expect(response).to redirect_to sign_in_path
      end
      it 'resets user password' do
        post :save_password, user_id: jay.id, password: '456'
        expect(User.first.authenticate('456')).to eq(jay)
      end
      it 'sets flash message' do
        post :save_password, user_id: jay.id, password: '456'
        expect(flash[:info]).to eq('Password had been reset')
      end
      it 'sets user token back to nil' do
        post :save_password, user_id: jay.id, password: '456'
        expect(User.first.token).to be_nil
      end
    end
    
    context 'with invalid input' do
      it 'renders update password page' do
        post :save_password, user_id: jay.id, password: ''
        expect(response).to render_template :update_password
      end
      it 'does not reset user password' do
        post :save_password, user_id: jay.id, password: ''
        expect(User.first.authenticate('123')).to eq(jay)
      end
    end
  end

end
