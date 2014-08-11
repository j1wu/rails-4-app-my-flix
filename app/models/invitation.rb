class Invitation < ActiveRecord::Base
  include Tokenable

  validates_presence_of :invitee_name, :invitee_email, :message

end
