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
    find("a[href='/videos/#{annie_hall.id}']").click
    expect(page).to have_content(annie_hall.title)

    # add video to queue
    click_link "+ My Queue"
    expect(page).to have_content('List Order')

    # '+My Queue' button shouldn't be there if video exsits in queue
    visit video_path(annie_hall)
    expect(page).to_not have_content('+ My Queue')

    # add more videos to queue
    visit home_path
    find("a[href='/videos/#{god_father.id}']").click
    click_link "+ My Queue"
    visit home_path
    # find by anchor sytax: find("a[]")
    find("a[href='/videos/#{seven.id}']").click
    click_link "+ My Queue"
    expect(page).to have_content(annie_hall.title)
    expect(page).to have_content(god_father.title)
    expect(page).to have_content(seven.title)

    # fill in queue item position, solution #1: changing the html element id 
    # what it looks like in view: id: "video_#{video.id}"
    visit my_queue_path
    fill_in "video_#{annie_hall.id}", with: 3
    fill_in "video_#{seven.id}", with: 2
    fill_in "video_#{god_father.id}", with: 1
    click_button("Update Instant Queue")
    # find by ID sytax: find("#id")
    expect(find("#video_#{annie_hall.id}").value).to eq("3")
    expect(find("#video_#{seven.id}").value).to eq("2")
    expect(find("#video_#{god_father.id}").value).to eq("1")

    # fill in queue item position, solution #2: adding data attribute
    # what it looks like in view: data: { video_id: video.id }
    find("input[data-video-id='#{annie_hall.id}']").set(1)
    find("input[data-video-id='#{god_father.id}']").set(2)
    find("input[data-video-id='#{seven.id}']").set(3)
    click_button("Update Instant Queue")
    expect(find("input[data-video-id='#{annie_hall.id}']").value).to eq("1")
    expect(find("input[data-video-id='#{god_father.id}']").value).to eq("2")
    expect(find("input[data-video-id='#{seven.id}']").value).to eq("3")
    
    # fill in queue item position, solution #3: scoping feature and xpath
    within(:xpath, "//tr[contains(.,'#{annie_hall.title}')]") do
      fill_in "queue_items[][position]", with: 4
    end
    click_button("Update Instant Queue")
    expect(find(:xpath, "//tr[contains(.,'#{annie_hall.title}')]//input[@type='text']").value).to eq("3")

  end

end
