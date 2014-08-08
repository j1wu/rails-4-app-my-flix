require 'spec_helper'

describe InvitationsController do

  describe 'POST create' do
    context 'with authenticated user' do
      context 'with valid input' do
        before do
          set_current_user
          post :create, full_name: 'Joe Doe', email: 'joe@example.com', message: '!'
        end
        after { ActionMailer::Base.deliveries.clear }
        it 'redirects user to invitation page' do
          expect(response).to redirect_to invitation_path
        end
        it 'sets flash message' do
          expect(flash[:success]).to eq('Invitation sent!')
        end
        it 'sends out invitation email' do
          expect(ActionMailer::Base.deliveries).not_to be_empty 
        end
      end
      context 'with invalid input' do
        before do
          set_current_user
          post :create, full_name: '', email: '', message: '!'
        end
        it 'redirects user to invitation page' do
          expect(response).to redirect_to invitation_path
        end
        it 'sets error message' do
          expect(flash[:danger]).to eq('Missing name or email')
        end
      end
    end
    context 'with unauthenticated user' do
      before do
        post :create, full_name: 'Joe Doe', email: 'joe@example.com', message: '!'
      end
      it 'redirects user to sign in page' do
        expect(response).to redirect_to sign_in_path
      end
    end
  end

end
