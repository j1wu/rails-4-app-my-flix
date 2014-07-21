require 'spec_helper'

describe VideosController do

  describe 'GET show' do
    let!(:fight_club) { Fabricate(:video) }

    context 'authenticated' do
      before do
        user = Fabricate(:user)
        session[:user_id] = user.id
      end
      it 'sets @video variable' do 
        get :show, id: fight_club.id
        expect(assigns(:video)).to eq(fight_club)
      end
      it 'renders show template' do
        get :show, id: fight_club.id
        expect(response).to render_template :show
      end
    end

    context 'unauthenticated' do
      it 'does not set @video variable' do
        get :show, id: fight_club.id
        expect(assigns(:video)).to eq(nil)
      end
      it 'redirect user to sign in page' do 
        get :show, id: fight_club.id
        expect(response).to redirect_to sign_in_path
      end
    end

  end

  describe 'POST search' do
    let!(:south_park) { Fabricate(:video, title: 'South Park') }

    context 'authenticated' do
      before do
        user = Fabricate(:user)
        session[:user_id] = user.id
      end
      it 'sets @results variable' do
        post :search, search_term: 'South Park'
        expect(assigns(:results)).to eq([south_park])
      end
      it 'renders search template' do
        post :search, search_term: 'South Park'
        expect(response).to render_template :search
      end
    end
    
    context 'unauthenticated' do
      it 'does not set @results variable' do
        post :search, search_term: 'South Park'
        expect(assigns(:results)).to eq(nil)
      end
      it 'redirect user to sign in page' do
        post :search, search_term: 'South Park'
        expect(response).to redirect_to sign_in_path
      end
    end
  end

end