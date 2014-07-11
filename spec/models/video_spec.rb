require 'spec_helper'

describe Video do
  it 'saves video' do
    video = Video.new(title: 'Fight Club', description: 'N/A')
    video.save
    Video.first.title.should == 'Fight Club'
  end
end