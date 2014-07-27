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

  describe 'POST update_queue' do
    let(:alice) { Fabricate(:user) }
    let(:queue_item1) { Fabricate(:queue_item, user: alice, position: 1) }
    let(:queue_item2) { Fabricate(:queue_item, user: alice, position: 2) }
    context 'with valid input' do
      before do
        session[:user_id] = alice.id
      end
      it 'redirects to the my queue page' do
        post :update_queue, queue_items: [{id: queue_item1.id, position: 2}, {id: queue_item2.id, position: 1}]
        expect(response).to redirect_to my_queue_path
      end
      it 'reorders the queue items' do
        post :update_queue, queue_items: [{id: queue_item1.id, position: 2}, {id: queue_item2.id, position: 1}]
        expect(queue_item1.reload.position).to eq(2)
        expect(queue_item2.reload.position).to eq(1)
      end
      it 'normalizes the position numbers' do
        post :update_queue, queue_items: [{id: queue_item1.id, position: 3}, {id: queue_item2.id, position: 2}]
        expect(queue_item1.reload.position).to eq(2)
        expect(queue_item2.reload.position).to eq(1)
      end
    end

    context 'with invalid inputs' do
      let(:alice) { Fabricate(:user) }
      let(:queue_item1) { Fabricate(:queue_item, user: alice, position: 1) }
      let(:queue_item2) { Fabricate(:queue_item, user: alice, position: 2) }
      before do
        session[:user_id] = alice.id
      end
      it 'redirects to the my queue page' do
        post :update_queue, queue_items: [{id: queue_item1.id, position: ''}, {id: queue_item2.id, position: 1.1}]
        expect(response).to redirect_to my_queue_path
      end
      it 'sets the flash error message' do
        post :update_queue, queue_items: [{id: queue_item1.id, position: ''}, {id: queue_item2.id, position: 1.1}]
        expect(flash[:danger]).to be_present 
      end
      it 'does not change the queue items' do
        post :update_queue, queue_items: [{id: queue_item1.id, position: ''}, {id: queue_item2.id, position: 1.1}]
        expect(alice.queue_items.map(&:position)).to eq([1, 2])
      end
    end

    context 'with unauthenticated users' do
      it 'redirects to sign in path' do
        queue_item1 = Fabricate(:queue_item, position: 1)
        queue_item2 = Fabricate(:queue_item, position: 2)
        post :update_queue, queue_items: [{id: queue_item1.id, position: 2}, {id: queue_item2.id, position: 1}]
        expect(response).to redirect_to sign_in_path 
      end
    end
    context 'with queue items that do not belongs to the current user' do
      it 'does not change the queue items' do
        alice = Fabricate(:user)
        bob = Fabricate(:user)
        session[:user_id] = alice.id
        queue_item1 = Fabricate(:queue_item, user: alice, position: 1) 
        queue_item2 = Fabricate(:queue_item, user: bob, position: 1)
        post :update_queue, queue_items: [{id: queue_item2.id, position: 2}]
        expect(queue_item2.reload.position).to eq(1)
      end
    end
  end

end
