require 'spec_helper'

describe Category do

  it 'saves category' do
    drama = Category.new(name: 'Drama')
    drama.save
    Category.first.name.should == 'Drama'
  end

  it 'has many videos' do
    drama = Category.create(name: 'Drama')
    godfather = Video.create(title: 'God Father', description: 'n/a', category: drama)
    anniehall = Video.create(title: 'Annie Hall', description: 'n/a', category: drama)
    expect(drama.videos).to eq([anniehall, godfather])
  end

end