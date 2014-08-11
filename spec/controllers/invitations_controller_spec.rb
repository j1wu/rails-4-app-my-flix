require 'spec_helper'

describe InvitationsController do

  describe 'GET new' do
    before do
      set_current_user
      get :new
    end
    it 'sets @invitation' do
      expect(assigns(:invitation)).to be_an_instance_of(Invitation)
    end
    it_behaves_like 'require_sign_in' do
      let(:action) { get :new }
    end
  end

  describe 'POST create' do
    context 'with valid input' do
      before do
        set_current_user
        post :create, invitation: {invitee_name: 'Guillermo del Toro', invitee_email: 'hellokitty@example.com', message: 'Hello world'}, inviter_id: current_user.id
      end
      after { ActionMailer::Base.deliveries.clear }
      it 'redirects user to invitation page' do
        expect(response).to redirect_to invitation_path 
      end
      it 'sets flash message' do
        expect(flash[:success]).not_to be_nil
      end
      it 'creates a new invitation record' do
        expect(Invitation.count).to eq(1)
      end
      it 'sends out invitation email' do
        expect(ActionMailer::Base.deliveries).not_to be_empty
      end
      it 'sends out invitation email to invitee' do
        expect(ActionMailer::Base.deliveries.last.to).to eq(['hellokitty@example.com'])
      end
    end
    context 'with invalid input' do
      before do
        set_current_user
        post :create, invitation: {invitee_name: '', invitee_email: '', message: 'Hello world'}, inviter_id: current_user.id
      end
      it 'redirects user to invitation page' do
        expect(response).to redirect_to invitation_path
      end
      it 'sets flash message' do
        expect(flash[:danger]).not_to be_nil
      end
      it 'does not create invitation record' do
        expect(Invitation.count).to eq(0)
      end
    end
  end

end
