require 'spec_helper'

describe Invitation do

  it { should validate_presence_of :invitee_name }
  it { should validate_presence_of :invitee_email }
  it { should validate_presence_of :message }

end
