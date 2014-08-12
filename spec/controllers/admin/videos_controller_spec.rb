require 'spec_helper'

describe Admin::VideosController do

  describe 'GET new' do
    it_behaves_like 'require_sign_in' do
      let(:action) { get :new }
    end
    it_behaves_like 'require_admin' do
      let(:action) { get :new }
    end
    it 'sets flash message for regular user' do
      set_current_user
      get :new
      expect(flash[:danger]).not_to be_nil
    end
    it 'could access by admin user' do
      set_current_admin_user
      get :new
      expect(response).to render_template :new
      expect(flash[:danger]).to be_nil
    end
  end

end
