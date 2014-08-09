require 'spec_helper'

feature 'user invites user' do

  scenario 'user invites user' do
    # set up
    bob = Fabricate(:user)

    # sends out invitation
    sign_in bob
    visit invitation_path
    fill_in 'full_name', with: 'New Friend'
    fill_in 'email', with: 'friend@example.com'
    find_button('Send Invitation').click

    # sign out bob
    visit sign_out_path
    
    open_email 'friend@example.com'
    current_email.find_link('join the party!').click
    
    expect(find(:id, 'user_email').value).to eq('friend@example.com')

    # registers new user
    fill_in 'Password', with: '456'
    fill_in 'Full Name', with: 'New Friend'
    find_button('Sign Up').click
    expect(page).to have_content('Sign in')

    # sign in
    fill_in 'Email Address', with: 'friend@example.com'
    fill_in 'Password', with: '456'
    click_button 'Sign in'
    expect(page).to have_content('You are signed in!')

    # examines friendship
    visit user_path bob
    expect(page).not_to have_content('Follow')

    # sign new friend out
    visit sign_out_path

    # sign bob in
    sign_in bob

    # examines friendship
    visit people_path
    expect(page).to have_content('New Friend')

  end

end
