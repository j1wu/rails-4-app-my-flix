class AppMailer < ActionMailer::Base

  def welcome_to_myflix(user)
    @user = user
    mail from: 'tylr.wu+myflix@gmail.com', to: user.email, subject: "Welcome to MyFliX!"
  end

  def reset_password(user)
    @user = user 
    mail from: 'tylr.wu+myflix@gmail.com', to: user.email, subject: "Reset your MyFliX password"
  end

end
