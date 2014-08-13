require 'spec_helper'

feature 'add video' do

  scenario 'add and view added video' do
    # set up as admin
    Fabricate(:category, name: 'Drama')
    bob = Fabricate(:user, admin: true)
    sign_in(bob)
    visit admin_add_video_path

    # add video
    fill_in 'Title', with: 'Fight Club'
    fill_in 'Description', with: 'Two thumbs up!'
    select 'Drama', from: 'video_category_id'
    attach_file 'video_large_cover', 'public/tmp/monk_large.jpg'
    attach_file 'video_small_cover', 'public/tmp/monk.jpg'
    fill_in 'video_video_url', with: 'https://s3-ap-northeast-1.amazonaws.com/myflixforeveryone/apparently.mp4'
    find_button('Add Video').click
    expect(page).to have_content('Video added')

    # set up regular user 
    visit sign_out_path
    john = Fabricate(:user)
    sign_in(john)

    # view video
    visit video_path(Video.last)
    expect(page).to have_selector("img[src='/uploads/monk_large.jpg']")
    expect(page).to have_selector("a[href^='https://s3']")
  end

end
