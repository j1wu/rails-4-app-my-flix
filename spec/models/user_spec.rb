require 'spec_helper'

describe User do

  it { should have_many(:queue_items).order('position') }
  it { should have_many :reviews }
  it { should validate_presence_of :email }
  it { should validate_presence_of :password }
  it { should validate_presence_of :full_name }
  it { should validate_uniqueness_of :email }

  describe '#reviews_with_content' do
    it 'returns reviews with content' do
      user = Fabricate(:user)
      review1 = Fabricate(:review, user: user)
      review2 = Review.new(content: nil, user: user)
      review2.save(validate: false)
      expect(user.reviews_with_content.count).to eq(1)
    end
  end

end
