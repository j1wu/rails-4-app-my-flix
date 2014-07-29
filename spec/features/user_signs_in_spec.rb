require 'spec_helper'

feature 'User signs in' do

  background do
    User.create(email: 'doe@example.com', password: '123', full_name: 'John Doe')
  end

  scenario 'with correct email and password' do
    visit sign_in_path
    fill_in 'Email Address', with: 'doe@example.com'
    fill_in 'Password', with: '123'
    click_button 'Sign in'
    expect(page).to have_content('You are signed in!')
  end

  scenario 'with incorrect email or password' do
    visit sign_in_path
    fill_in 'Email Address', with: 'john@example.com'
    fill_in 'Password', with: '123'
    click_button 'Sign in'
    expect(page).to have_content('Invalid email or password')
  end

end
