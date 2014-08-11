class Invitation < ActiveRecord::Base

  validates_presence_of :invitee_name, :invitee_email, :message

  before_create :generate_token

  private
  def generate_token
   self.token = SecureRandom.urlsafe_base64 
  end
end
