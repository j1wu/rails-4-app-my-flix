def set_current_user user=nil
  user = user || Fabricate(:user)
  session[:user_id] = user.id
end

def set_current_admin_user user=nil
  user = user || Fabricate(:user, admin: true)
  session[:user_id] = user.id
end

def current_user
  User.find(session[:user_id])
end

def clear_current_user
  session[:user_id] = nil
end

def sign_in user=nil
  user = user || Fabricate(:user)
  visit sign_in_path
  fill_in 'Email Address', with: user.email
  fill_in 'Password', with: user.password
  click_button 'Sign in'
end
