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

end