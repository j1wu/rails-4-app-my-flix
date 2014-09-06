require 'spec_helper'

feature 'user invites user' do

  scenario 'user invites user', js: true, vcr: true do
    # set up
    bob = Fabricate(:user)

    # sends out invitation
    sign_in bob
    visit invitation_path
    fill_in "Friend's Name", with: 'New Friend'
    fill_in "Friend's Email Address", with: "join@example.com"
    find_button('Send Invitation').click

    # sign out bob
    visit sign_out_path
    
    open_email "join@example.com"
    current_email.click_link('join the party!')

    # registers new user
    fill_in 'Full Name', with: 'New Friend'
    fill_in 'Password', with: '456'
    fill_in 'Credit Card Number', with: '4242424242424242'
    fill_in 'Security Code', with: '323'
    select '7 - July', from: 'date_month'
    select '2015', from: 'date_year'
    find_button('Sign Up').click
    expect(page).to have_content('Sign in')

    # sign in
    fill_in 'Email Address', with: 'join@example.com'
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
