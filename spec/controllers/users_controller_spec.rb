require 'spec_helper'

describe UsersController do 

  describe 'POST create' do
    context 'valid input' do
      before do
        post :create, user: {email: 'john@example.com', password: '123', full_name: 'john smith'}
      end
      it 'creates user record' do
        expect(User.first.email).to eq('john@example.com')
      end
      it 'redirects user to sign in path' do
        expect(response).to redirect_to sign_in_path
      end
    end

    context 'invalid input' do
      before do
        post :create, user: {email: 'john@example.com', password: '', full_name: 'john smith'}
      end
      it 'does not create user record' do
        expect(User.count).to eq(0)
      end
      it 'renders new template' do
        expect(response).to render_template :new
      end
    end
  end

end