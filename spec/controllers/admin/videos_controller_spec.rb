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
      expect(flash[:danger]).to be_present
    end
    it 'could access by admin user' do
      set_current_admin_user
      get :new
      expect(response).to render_template :new
    end
    it 'sets @video' do
      set_current_admin_user
      get :new
      expect(assigns(:video)).not_to be_nil
    end
  end
  
  describe 'POST create' do
    it_behaves_like 'require_sign_in' do
      let(:action) { post :create }
    end
    it_behaves_like 'require_admin' do
      let(:action) { post :create }
    end
    context 'with valid input' do
      let(:cat) { Fabricate(:category) }
      before do
        set_current_admin_user
        post :create, video: {title: 'Fight Club', category_id: cat.id, description: 'First rule of...'}
      end
      it 'redirects user to add video page' do
        expect(response).to redirect_to admin_add_video_path
      end
      it 'sets flash message' do
        expect(flash[:success]).to be_present
      end
      it 'creates video record' do
        expect(cat.videos.count).to eq(1)
      end
    end
    context 'with invalid input' do
      before do
        set_current_admin_user
        post :create, video: {title: '', category_id: '', description: ''}
      end
      it 'does not create video record' do
        expect(Video.count).to eq(0)
      end
      it 'renders new template' do
        expect(response).to render_template :new
      end
      it 'sets @video' do
        expect(assigns(:video)).not_to be_nil
      end
    end
  end

end
