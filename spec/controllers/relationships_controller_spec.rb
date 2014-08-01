require 'spec_helper'

describe RelationshipsController do

  describe 'GET index' do
    it 'sets @relationships fro authenticated user' do
      set_current_user
      bob = current_user
      john = Fabricate(:user)
      relationship = Fabricate(:relationship, leader: john, follower: bob)
      get :index
      expect(assigns(:relationships)).to eq([relationship])
    end
    it_behaves_like 'require_sign_in' do
      let(:action) { get :index }
    end
  end

  describe 'DELETE destroy' do
    before do
      set_current_user
    end
    it 'redirect user to people page after deleting' do
      bob = current_user
      john = Fabricate(:user)
      relationship = Fabricate(:relationship, leader: bob, follower: john)
      delete :destroy, id: relationship.id
      expect(response).to redirect_to people_path
    end
    it 'deletes relationship' do
      bob = current_user
      john = Fabricate(:user)
      relationship = Fabricate(:relationship, leader: john, follower: bob)
      delete :destroy, id: relationship.id
      expect(Relationship.count).to eq(0)
    end
    it 'deletes only users own relationship' do
      bob = current_user
      alice = Fabricate(:user)
      john = Fabricate(:user)
      relationship = Fabricate(:relationship, leader: alice, follower: john)
      delete :destroy, id: relationship.id
      expect(Relationship.count).to eq(1)
    end
  end

end
