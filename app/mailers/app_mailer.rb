class AppMailer < ActionMailer::Base

  def welcome_to_myflix(user)
    @user = user
    mail from: 'tylr.wu+myflix@gmail.com', to: user.email, subject: "Weclome to MyFliX!"
  end

end
