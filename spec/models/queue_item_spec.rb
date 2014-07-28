require 'spec_helper'

describe QueueItem do

  it { should belong_to :video }
  it { should belong_to :user }
  it { should validate_numericality_of(:position).only_integer }

  describe '#rating' do
    it 'returns the rating of the associated video if rating is present' do
      user = Fabricate(:user)
      video = Fabricate(:video)
      review = Fabricate(:review, video: video, user: user, rating: 4)
      queue_item = Fabricate(:queue_item, user: user, video: video)
      expect(queue_item.rating).to eq(4)
    end
    it 'returns nil if the rating of the associated video is not present' do
      user = Fabricate(:user)
      video = Fabricate(:video)
      review = Fabricate(:review, video: video)
      queue_item = Fabricate(:queue_item, user: user, video: video)
      expect(queue_item.rating).to eq(nil)
    end
  end

end
