require 'spec_helper'

feature 'Social networking' do

  scenario 'user follows and unfolows another user' do

    # set up
    drama = Fabricate(:category)
    annie_hall = Fabricate(:video, title: 'Annie Hall', category: drama)

    john = Fabricate(:user)
    bob = Fabricate(:user, full_name: 'Bob Henry')
    peter = Fabricate(:user, full_name: 'Peter Cruso')

    review1 = Fabricate(:review, video: annie_hall, user: bob)
    review2 = Fabricate(:review, video: annie_hall, user: peter)
    
    relationship = Fabricate(:relationship, leader: bob, follower: peter)

    # sign in 
    sign_in john

    # visit video show page
    visit video_path annie_hall
    expect(page).to have_content('Bob Henry')

    # visit user page
    click_link bob.full_name 
    expect(page).to have_content("Bob Henry's video collections")

    # follow user
    click_link 'Follow'
    expect(page).to have_content('People I Follow')
    expect(page).to have_content('Bob Henry')

    # visit followed user page do not see the follow button
    visit user_path(bob)
    expect(page).not_to have_content('Follow')

    # unfollow user
    visit people_path
    find("a[href^='/relationships/']").click
    expect(page).not_to have_content('Bob Henry')

  end

end
