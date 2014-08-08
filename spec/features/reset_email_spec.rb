require 'spec_helper'

feature 'user resets password' do

  scenario 'users resets password' do
    user = Fabricate(:user, email: 'xmen@example.com', password: '123')
    
    forgot_password
    enter_email_to_request_reset user.email

    open_email(user.email)
    expect(current_email).to have_content("#{user.full_name}, please use the link")
    
    current_email.find_link('reset password').click
    expect(page).to have_content('Reset Your Password')
    
    enter_new_password '456'
    sign_in_with_new_password user.email, '456'
  end

  def forgot_password
    visit sign_in_path
    find_link('Forgot Password').click
    expect(page).to have_content('We will send you an email with a link')
  end

  def enter_email_to_request_reset email
    fill_in('Email Address', with: email)
    find_button('Send Email').click
    expect(page).to have_content('We have send an email with instruction')
  end

  def enter_new_password new_password
    fill_in('New Password', with: new_password)
    find_button('Reset Password').click
    expect(page).to have_content('Sign in')
  end

  def sign_in_with_new_password email, new_password
    fill_in('Email Address', with: email)
    fill_in('Password', with: new_password)
    find_button('Sign in').click
    expect(page).to have_content('You are signed in!')
  end

end
