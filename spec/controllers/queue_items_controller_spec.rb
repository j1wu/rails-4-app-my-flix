require 'spec_helper'

describe QueueItemsController do

  describe 'GET index' do
    it 'sets @queue_items associated with authenticated user' do
      set_current_user
      queue_item1 = Fabricate(:queue_item, user: current_user)
      queue_item2 = Fabricate(:queue_item, user: current_user)
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
      it_behaves_like 'require_sign_in' do
        let(:action) { post :create, id: video.id }
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
      it_behaves_like 'require_sign_in' do
        let(:action) { delete :destroy, id: Fabricate(:queue_item).id }
      end
    end
  end

  describe 'POST update_queue' do
    let(:alice) { Fabricate(:user) }
    let(:video) { Fabricate(:video) }
    let(:queue_item1) { Fabricate(:queue_item, user: alice, position: 1, video: video) }
    let(:queue_item2) { Fabricate(:queue_item, user: alice, position: 2, video: video) }
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
      
      it 'updates video user review rating if it already exists' do
        video = Fabricate(:video)
        review = Fabricate(:review, user: alice, video: video, rating: 3)
        queue_item = Fabricate(:queue_item, user: alice, video: video, position: 1)
        post :update_queue, queue_items: [{id: queue_item.id, position: 1, rating: 4}]
        expect(review.reload.rating).to eq(4)
      end
      it 'adds new review rating if video user view does not exists' do
        video = Fabricate(:video)
        queue_item = Fabricate(:queue_item, user: alice, video: video, position: 1)
        post :update_queue, queue_items: [{id: queue_item.id, position: 1, rating: 4}]
        expect(Review.first.rating).to eq(4)
      end
    end

    context 'with invalid inputs' do
      let(:alice) { Fabricate(:user) }
      let(:video) { Fabricate(:video) }
      let(:queue_item1) { Fabricate(:queue_item, user: alice, position: 1, video: video) }
      let(:queue_item2) { Fabricate(:queue_item, user: alice, position: 2, video: video) }
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
      let(:video1) { Fabricate(:video) }
      let(:video2) { Fabricate(:video) }

      it_behaves_like 'require_sign_in' do
        let(:action) { post :update_queue, queue_items: [] }
      end

    end

    context 'with queue items that do not belongs to the current user' do
      let(:video1) { Fabricate(:video) }
      let(:video2) { Fabricate(:video) }
      it 'does not change the queue items' do
        alice = Fabricate(:user)
        bob = Fabricate(:user)
        session[:user_id] = alice.id
        queue_item1 = Fabricate(:queue_item, user: alice, position: 1, video: video1) 
        queue_item2 = Fabricate(:queue_item, user: bob, position: 1, video: video2)
        post :update_queue, queue_items: [{id: queue_item2.id, position: 2}]
        expect(queue_item2.reload.position).to eq(1)
      end
    end
  end

end
