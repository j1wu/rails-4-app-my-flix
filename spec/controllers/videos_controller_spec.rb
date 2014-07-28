require 'spec_helper'

describe VideosController do

  describe 'GET show' do
    let(:fight_club) { Fabricate(:video) }

    context 'authenticated' do
      before do
        set_current_user
      end
      it 'sets @video variable' do 
        get :show, id: fight_club.id
        expect(assigns(:video)).to eq(fight_club)
      end

      it 'sets @review variable' do
        get :show, id: fight_club.id
        expect(assigns(:review)).to be_an_instance_of(Review)
      end

      it 'sets @reviews variable' do
        get :show, id: fight_club.id
        review1 = Fabricate(:review, video: fight_club)
        review2 = Fabricate(:review, video: fight_club)
        expect(assigns(:reviews)).to match_array([review1, review2])
      end

      it 'orders most recent review on top' do
        get :show, id: fight_club.id
        review1 = Fabricate(:review, video: fight_club, created_at: 1.day.ago)
        review2 = Fabricate(:review, video: fight_club, created_at: 2.day.ago)
        review3 = Fabricate(:review, video: fight_club)
        expect(assigns(:reviews)).to eq([review3, review1, review2])
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
      it_behaves_like 'require_sign_in' do
        let(:action) { get :show, id: Fabricate(:video).id }
      end
    end

  end

  describe 'POST search' do
    let(:south_park) { Fabricate(:video, title: 'South Park') }

    context 'authenticated' do
      before do
        set_current_user
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
      it_behaves_like 'require_sign_in' do
        let(:action) { post :search, search_term: 'south park' }
      end
    end
  end

end
