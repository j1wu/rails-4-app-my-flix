require 'spec_helper'

describe SessionsController do

  describe 'GET new' do
    context 'with authenticated user' do
      it 'redirects user to home path' do
        session[:user_id] = Fabricate(:user).id
        get :new
        expect(response).to redirect_to home_path
      end
    end

    context 'with unauthenticated user' do
      it 'renders new template' do
        get :new
        expect(response).to render_template :new
      end
    end
  end

  describe 'POST create' do
    let!(:john) { john = Fabricate(:user) }
    context 'with valid credentials' do
      before do
        # this is not a model-backed form
        post :create, email: john.email, password: john.password
      end
      it 'sets session' do
        expect(session[:user_id]).to eq(john.id)
      end
      it 'redirects user to home path' do
        expect(response).to redirect_to home_path
      end
      it 'sets flash message' do
        expect(flash[:info]).to eq('You are signed in!')
      end
    end

    context 'with invalid credentials' do
      before do
        post :create, email: john.email, password: ''
      end
      it 'does not set session' do
        expect(session[:user_id]).to eq(nil)
      end
      it 'redirects user to sign in path' do
        expect(response).to redirect_to(sign_in_path)
      end
      it 'set flash message' do
        expect(flash[:danger]).to eq('Invalid email or password')
      end
    end
  end

  describe 'DELETE destroy' do
    let!(:bob) { bob = Fabricate(:user) }
    before do
      session[:user_id] = bob.id
      get :destroy
    end
    it 'set session to nil' do
      expect(session[:user_id]).to eq(nil)
    end
    it 'redirects user to root path' do
      expect(response).to redirect_to root_path
    end
    it 'sets flash message' do
      expect(flash[:info]).to eq('You are signed out!')
    end
  end

end