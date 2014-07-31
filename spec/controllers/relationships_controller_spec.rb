require 'spec_helper'

describe RelationshipsController do

  describe 'GET index' do
    it 'sets @relationships fro authenticated user' do
      set_current_user
      bob = current_user
      john = Fabricate(:user)
      relationship = Fabricate(:relationship, leader: bob, follower: john)
      get :index
      expect(assigns(:relationships)).to eq([relationship])
    end
    it_behaves_like 'require_sign_in' do
      let(:action) { get :index }
    end
  end

end
