require 'spec_helper'

describe Relationship do

  describe '#duplicated?' do
    it 'return true if relationship already existed' do
      bob = Fabricate(:user)
      john = Fabricate(:user)
      relationship1 = Fabricate(:relationship, follower: john, leader: bob)
      relationship1 = Fabricate(:relationship, follower: john, leader: bob)
      expect(relationship1.duplicated?).to be_truthy
    end
  end

end
