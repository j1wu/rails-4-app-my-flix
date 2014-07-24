require 'spec_helper'

describe Video do

  it {should belong_to :category}
  it {should validate_presence_of :title}
  it {should validate_presence_of :description}

  it 'returns an empty array if no match' do
    fight_club = Video.create(title: 'Fight Club', description: 'n/a')
    result = Video.search_by_title('Father')
    expect(result).to eq([])
  end

  it 'returns an array of one video for exact match' do
    fight_club = Video.create(title: 'Fight Club', description: 'n/a')
    result = Video.search_by_title('Fight Club')
    expect(result).to eq([fight_club])
  end

  it 'returns an array of one video for partial match' do
    fight_club = Video.create(title: 'Fight Club', description: 'n/a')
    result = Video.search_by_title('Fight')
    expect(result).to eq([fight_club])
  end

  it 'returns an array of videos for partial match if more than one videos matched' do
    fight_club = Video.create(title: 'Fight Club', description: 'n/a')
    fight_for_it = Video.create(title: 'Fight For It', description: 'n/a')
    result = Video.search_by_title('Fight')
    expect(result).to eq([fight_club, fight_for_it])
  end

  it 'returns an array of videos for partial match if more than one videos matched regardless search term case-sensitivity' do
    fight_club = Video.create(title: 'Fight Club', description: 'n/a')
    fight_for_it = Video.create(title: 'Fight For It', description: 'n/a')
    result = Video.search_by_title('fight')
    expect(result).to eq([fight_club, fight_for_it])
  end

  it 'returns an array of videos for partial match if more than one videos matched ordered by title' do
    fight_club = Video.create(title: 'Fight Club', description: 'n/a')
    fight_a_game = Video.create(title: 'Fight A Game', description: 'n/a')
    result = Video.search_by_title('Fight')
    expect(result).to eq([fight_a_game, fight_club])
  end

  it 'returns an empty array if search term is empty' do
    fight_club = Video.create(title: 'Fight Club', description: 'n/a')
    result = Video.search_by_title('')
    expect(result).to eq([])
  end
  
end


describe 'average rating' do

  let(:fight_club) { Fabricate(:video) }

  context 'has no rating' do
    it 'sets average rating to not-yet-rated' do 
      expect(fight_club.average_rating).to eq('Not Yet Rated')
    end
  end

  context 'has rating' do
    it 'sets average rating as rounded float' do
      review1 = Fabricate(:review, video: fight_club, rating: 2)
      review2 = Fabricate(:review, video: fight_club, rating: 3)
      rating = fight_club.average_rating
      expect(rating).to eq(2.5)
    end
  end

end