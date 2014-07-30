require 'spec_helper'

feature 'User interacts with queue' do

  scenario 'user adds and reorders videos in the queue' do
    # set up
    drama = Fabricate(:category)
    annie_hall = Fabricate(:video, title: 'Annie Hall', category: drama)
    god_father = Fabricate(:video, title: 'God Fahter', category: drama)
    seven = Fabricate(:video, title: 'Seve', category: drama)

    # sign in and visit home page
    sign_in
    visit home_path
    expect(page).to have_content('Welcome, ')

    # visit video show page
    go_to_video(annie_hall)
    expect(page).to have_content(annie_hall.title)

    # add video to queue
    click_link "+ My Queue"
    expect(page).to have_content('List Order')

    # '+My Queue' button shouldn't be there if video exsits in queue
    visit video_path(annie_hall)
    expect_link_not_to_be_seen('+ My Queue')

    # add more videos to queue
    add_video_to_queue(god_father)
    add_video_to_queue(seven)
    expect_video_to_be_in_queue(annie_hall)
    expect_video_to_be_in_queue(god_father)
    expect_video_to_be_in_queue(seven)

    # fill in queue item position
    set_video_position(annie_hall, 3)
    set_video_position(seven, 2)
    set_video_position(god_father, 1)

    click_button("Update Instant Queue")

    expect_video_position(annie_hall, 3)
    expect_video_position(seven, 2)
    expect_video_position(god_father, 1)

  end

    def expect_link_not_to_be_seen(link_text)
      expect(page).to_not have_content('link_text')
    end

    def expect_video_to_be_in_queue(video)
      expect(page).to have_content(video.title)
    end
    
    def go_to_video(video)
      visit home_path
      find("a[href='/videos/#{video.id}']").click
    end

    def add_video_to_queue(video)
      visit home_path
      find("a[href='/videos/#{video.id}']").click
      click_link "+ My Queue"
    end

    def set_video_position(video, position)
      within(:xpath, "//tr[contains(.,'#{video.title}')]") do
        fill_in "queue_items[][position]", with: position
      end
    end

    def expect_video_position(video, position)
      expect(find(:xpath, "//tr[contains(.,'#{video.title}')]//input[@type='text']").value).to eq(position.to_s)
    end

end
