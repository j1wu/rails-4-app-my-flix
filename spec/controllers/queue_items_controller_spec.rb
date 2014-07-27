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

  describe 'DELETE destory' do
    let(:video) { Fabricate(:video) }
    let(:user) { Fabricate(:user) }
    context 'with authenticated user' do
      before do
        session[:user_id] = user.id
      end
      it 'redirects user back to my queue page' do
        queue_item = Fabricate(:queue_item, user: user, video: video)
        delete :destroy, id: queue_item.id
        expect(response).to redirect_to(my_queue_path)
      end
      it 'deletes queue item' do
        queue_item = Fabricate(:queue_item, user: user, video: video)
        delete :destroy, id: queue_item.id
        expect(QueueItem.count).to eq(0) 
      end
      it 'resets remaining queue items positon number' do
        queue_item1 = Fabricate(:queue_item, user: user, position: 1)
        queue_item2 = Fabricate(:queue_item, user: user, position: 2)
        queue_item3 = Fabricate(:queue_item, user: user, position: 3)
        delete :destroy, id: queue_item2.id
        expect(queue_item3.reload.position).to eq(2)
      end
    end
    context 'with unauthenticated user' do
      it 'does not delete queue item' do
        queue_item = Fabricate(:queue_item, user: user, video: video)
        delete :destroy, id: queue_item.id
        expect(QueueItem.count).to eq(1) 
      end
      it 'redirects user to sign in path' do
        queue_item = Fabricate(:queue_item, user: user, video: video)
        delete :destroy, id: queue_item.id
        expect(response).to redirect_to sign_in_path
      end
    end
  end

  describe 'POST update' do
    let(:user) { Fabricate(:user) }
    context 'with valid input' do
      before do
        session[:user_id] = user.id
      end
      it 'redirects user to my queue page' do
        post :update
        expect(response).to redirect_to my_queue_path
      end

      end
      it 'updates queue items positions' do
        video1 = Fabricate(:video)
        video2 = Fabricate(:video)
        queue_item1 = Fabricate(:queue_item, video: video1, user: user, position: 1)
        queue_item2 = Fabricate(:queue_item, video: video2, user: user, position: 2)
        # this is the params[:queue_items] format I'm getting
        # "queue_items"=>{"id"=>["1", "2"], "position"=>["2", "1"]}
        # that's why I'm passing the same format of params here, but the test wont pass
        # and I just not able to capture what params exactly this test pass to the controller
        # I tried binding.pry in the controller code, but the interactive
        # mode, both queue_items and params came back empty...I dont know why
        post :update, queue_items: {id: [queue_item1.id, queue_item2.id], position: [queue_item2.position, queue_item1.position]}
        expect(queue_item1.reload.position).to eq(2)
        expect(queue_item2.reload.position).to eq(1)
      end
      it 're-orders queue items base on the new positions' do
        video1 = Fabricate(:video)
        video2 = Fabricate(:video)
        queue_item1 = Fabricate(:queue_item, video: video1, user: user, position: 1)
        queue_item2 = Fabricate(:queue_item, video: video2, user: user, position: 2)
        # this wont pass neither, but it kinda works in the browswer
        post :update, queue_items: {id: [queue_item1.id, queue_item2.id], position: [queue_item2.position, queue_item1.position]}
        expect(user.queue_items.first).to eq(queue_item2)
      end
  end

end
