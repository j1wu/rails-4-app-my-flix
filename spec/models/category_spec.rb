require 'spec_helper'

describe Category do

  it {should have_many :videos}

end

describe 'recent_videos' do

  it 'returns all videos if there are less than 6 videos' do
    drama = Category.create(name: 'Drama')
    fight_club = Video.create(title: 'Fight Club', description: 'n/a', category: drama)
    expect(drama.recent_videos.count).to eq(1)
  end
  
  it 'returns 6 videos if there are more than 6 videos' do
    drama = Category.create(name: 'drama')
    7.times.each do |video|
      video = Video.create(title: 'Fight Club', description: 'n/a', category: drama)
    end 
    expect(drama.recent_videos.count).to eq(6)
  end

  it 'returns 6 videos order by created at in reverse order' do
    drama = Category.create(name: 'drama')
    7.times.each do |video|
      video = Video.create(title: 'Fight Club', description: 'n/a', category: drama, created_at: 2.days.ago)
    end 
    fight_club = Video.create(title: 'Fight Club', description: 'n/a', category: drama, created_at: 1.day.ago)
    expect(drama.recent_videos.first).to eq(fight_club)
  end

  it 'returns an empty array if there are no video' do
    drama = Category.create(name: 'drama')
    expect(drama.recent_videos.count).to eq(0)
  end

end