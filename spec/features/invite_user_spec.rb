require 'spec_helper'

feature 'user invites user' do

  scenario 'user sends out invitation' do
    sign_in
    visit invitation_path
    fill_in 'full_name', with: 'New Friend'
    fill_in 'email', with: 'friend@example.com'
    find_button('Send Invitation').click

    open_email 'friend@example.com'
    current_email.find_link('join the party!').click
    
    expect(find(:id, 'user_email').value).to eq('friend@example.com')
  end

end
