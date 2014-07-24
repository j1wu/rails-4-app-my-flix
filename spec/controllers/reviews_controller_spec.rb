require 'spec_helper'

describe ReviewsController do

  describe 'POST create' do

    let(:seven) { Fabricate(:video) }
    let(:bob) { Fabricate(:user) }

    context 'with authenticated user' do
      context 'with valid input' do
        before do
          session[:user_id] = bob.id
          post :create, review: Fabricate.attributes_for(:review), video_id: seven.id
        end
        it 'redirects user to video show page' do
          expect(response).to redirect_to video_path(seven)
        end
        it 'creates review' do
          expect(Review.count).to eq(1)
        end
        it 'creates review associated with the video' do
          expect(Review.first.video).to eq(seven)
        end
        it 'creates review associated with the user' do
          expect(Review.first.user).to eq(bob)
        end
      end
      context 'with invalid input' do
        before do
          session[:user_id] = bob.id
        end
        it 'sets @video' do
          post :create, review: {rating: '', content: ''}, video_id: seven.id
          expect(assigns(:video)).to eq(seven)
        end
        it 'sets @review' do
          post :create, review: {rating: '', content: ''}, video_id: seven.id
          expect(assigns(:review)).to be_an_instance_of(Review)
        end
        it 'does not create review if no rating' do
          post :create, review: {rating: '', content: 'something'}, video_id: seven.id
          expect(Review.count).to eq(0)
        end
        it 'does not create review if no content' do
          post :create, review: {rating: '5', content: ''}, video_id: seven.id
          expect(Review.count).to eq(0)
        end
        it 'renders user to video show template' do
          post :create, review: {rating: '', content: ''}, video_id: seven.id
          expect(response).to render_template('videos/show')
        end
        it 'sets error message' do
          post :create, review: {rating: '', content: ''}, video_id: seven.id
          expect(flash[:danger]).to eq('Rating or content cannot be blank')
        end
        it 'persists review content if no rating' do
          post :create, review: {rating: '', content: 'keep this!'}, video_id: seven.id
          expect(assigns(:review).content).to eq('keep this!')
        end
      end
    end

    context 'with unauthenticated user' do
      before do
        post :create, review: Fabricate.attributes_for(:review), video_id: seven.id
      end
      it 'does not create review' do
        expect(Review.count).to eq(0)
      end
      it 'redirects user to sign in page' do
        expect(response).to redirect_to sign_in_path
      end
    end

  end

end