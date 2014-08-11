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
      it 'does not creates relationship' do
        expect(Relationship.count).to eq(0)
      end
    end

    context 'with invitation' do
      let(:user) { Fabricate(:user) }
      before do
        post :create, user: Fabricate.attributes_for(:user), inviter_id: user.id
      end
      it 'creates user record' do
        expect(User.count).to eq(2)
      end 
      it 'follows inviter automatically' do
        expect(User.last.following_relationships.pluck(:leader_id)).to include(user.id)
      end
      it 'being followed by inviter' do
        expect(User.last.leading_relationships.pluck(:follower_id)).to include(user.id)
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

  describe 'GET register_with_invitation' do
    context 'with valid token' do
      before do
        invitation = Fabricate(:invitation, inviter_id: 1, token: 'abc')
        get :register_with_invitation, token: invitation.token
      end
      it 'sets @user' do
        expect(assigns(:user)).not_to be_nil
      end
      it 'sets @invitation' do
        expect(assigns(:invitation)).not_to be_nil 
      end
    end
    context 'with invalid token' do
      it 'redirects user to expired token page' do
        get :register_with_invitation, token: 'efg'
        expect(response).to redirect_to expired_token_path 
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

end
