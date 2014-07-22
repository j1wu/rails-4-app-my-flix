Fabricator(:review) do

  content { Faker::Lorem.words(5).join(" ") }
  rating { (0..5).to_a.sample }

end