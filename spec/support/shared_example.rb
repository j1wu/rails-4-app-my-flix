shared_examples "require_sign_in" do
  it 'redirects user to sign in page' do
    clear_current_user
    action
    expect(response).to redirect_to sign_in_path
  end
end

shared_examples "require_admin" do
  it 'redirects user to home page' do
    set_current_user
    action
    expect(response).to redirect_to home_path
  end
end
