require 'spec_helper'

describe QueueItemsController do

  describe 'GET index' do
    it 'sets @queue_items associated with authenticated user' do
      bob = Fabricate(:user)
      session[:user_id] = bob.id
      queue_item1 = Fabricate(:queue_item, user: bob)
      queue_item2 = Fabricate(:queue_item, user: bob)
      get :index
      expect(assigns(:queue_items)).to match_array([queue_item1, queue_item2]) 
    end
    it 'redirects unauthenticated user to sign in path' do
      get :index
      expect(response).to redirect_to sign_in_path
    end
  end

  describe 'POST create' do
    let(:video) { Fabricate(:video) }
    let(:user) { Fabricate(:user) }
    context 'with authenticated user' do
      before do
        session[:user_id] = user.id
      end
      it 'redirects user to my queue page' do
        queue_item = Fabricate(:queue_item, user: user)
        post :create, id: video.id
        expect(response).to redirect_to(my_queue_path)
      end
      it 'creates a queue item' do
        post :create, id: video.id
        expect(QueueItem.count).to eq(1)
      end
      it 'does not create a queue item if video already added in queue' do
        queue_item = Fabricate(:queue_item, user: user, video: video)
        post :create, id: video.id
        expect(QueueItem.count).to eq(1)
      end
      it 'sets flah informaiton' do
        queue_item = Fabricate(:queue_item, user: user, video: video)
        post :create, id: video.id
        expect(flash[:info]).to eq('Video already exsited in queue')
      end
      it 'sets queue item position number' do
        video2 = Fabricate(:video)
        queue_item = Fabricate(:queue_item, user: user, video: video)
        post :create, id: video2.id
        expect(QueueItem.last.position).to eq(2)
      end
    end
    context 'with unauthenticated user' do
      it 'does not create a queue item' do
        post :create, id: video.id
        expect(QueueItem.count).to eq(0) 
      end
      it 'redirects user to sign in page' do
        post :create, id: video.id
        expect(response).to redirect_to sign_in_path
      end
    end
  end

end