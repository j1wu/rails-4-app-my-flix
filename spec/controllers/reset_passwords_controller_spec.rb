require 'spec_helper'

describe ResetPasswordsController do

  describe 'GET show' do
    let!(:jay) { Fabricate(:user, email: 'jay@example.com', password: '123', token: 'abc') }
    it 'sets flash message with valid token' do
      get :show, id: 'abc'
      expect(flash[:info]).to eq('Please enter the new password')
    end
    it 'sets @user instance variable' do
      get :show, id: 'abc'
      expect(assigns(:user)).to eq(jay)
    end
    it 'redirects user to register page with invalid token' do
      get :show, id: 'efg'
      expect(response).to redirect_to expired_token_path
    end
  end

  describe 'POST create' do
    let!(:jay) { Fabricate(:user, email: 'jay@example.com', password: '123', token: 'abc') }
    context 'with valid input' do
      it 'redirects user to sign in page' do
        post :create, user_id: jay.id, password: '456'
        expect(response).to redirect_to sign_in_path
      end
      it 'resets user password' do
        post :create, user_id: jay.id, password: '456'
        expect(User.first.authenticate('456')).to eq(jay)
      end
      it 'sets flash message' do
        post :create, user_id: jay.id, password: '456'
        expect(flash[:info]).to eq('Password had been reset')
      end
      it 'sets user token back to nil' do
        post :create, user_id: jay.id, password: '456'
        expect(User.first.token).to be_nil
      end
    end
    
    context 'with invalid input' do
      it 'does not reset user password' do
        post :create, user_id: jay.id, password: ''
        expect(User.first.authenticate('123')).to eq(jay)
      end
    end
  end

end
