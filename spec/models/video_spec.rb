require 'spec_helper'

describe Video do

  it 'saves video' do
    video = Video.new(title: 'Fight Club', description: 'N/A')
    video.save
    Video.first.title.should == 'Fight Club'
  end

  it 'belongs to category' do
    drama = Category.create(name: 'Drama')
    godfather = Video.create(title: 'God Father', category: drama)
    expect(godfather.category).to eq(drama)
  end

  it 'must has title' do
    video = Video.create(title: '', description: 'n/a')
    expect(Video.all.count).to eq(0)
  end

  it 'must has description' do 
    video = Video.create(title: 'Fight Club', description: '')
    expect(Video.all.count).to eq(0)
  end
  
end