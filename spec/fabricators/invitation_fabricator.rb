Fabricator(:invitation) do

  invitee_name { Faker::Name.name }
  invitee_email { Faker::Internet.email }
  message { Faker::Lorem.words(5).join(" ") }

end
