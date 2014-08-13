# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

john = User.create(email: 'john@example.com', password: '123', full_name: 'John Smith')

drama = Category.create(name: 'Drama')
scifi = Category.create(name: 'Sci-Fi')

Video.create(title: 'Annie Hall', description: 'N/A',  category: drama)
Video.create(title: 'Avengers', description: 'N/A',  category: scifi)
Video.create(title: 'Dark Night', description: 'N/A',  category: scifi)
Video.create(title: 'Godfather', description: 'N/A',  category: drama)
Video.create(title: 'Harry Potter', description: 'N/A',  category: scifi)
Video.create(title: 'Help', description: 'N/A',  category: drama)
Video.create(title: 'Hunt', description: 'N/A',  category: drama)
Video.create(title: 'Love Actually', description: 'N/A',  category: drama)
Video.create(title: 'Man On Fire', description: 'N/A',  category: drama)
Video.create(title: 'Misery', description: 'N/A',  category: drama)
Video.create(title: 'Moon', description: 'N/A',  category: scifi)
Video.create(title: 'No', description: 'N/A',  category: drama)
Video.create(title: 'Outrage', description: 'N/A',  category: drama)
seven = Video.create(title: 'Seven', description: 'N/A',  category: drama)
Video.create(title: 'Star Trek', description: 'N/A',  category: scifi)
Video.create(title: 'Trainspotting', description: 'N/A',  created_at: 3.days.ago)

review1 = Review.create(content: 'mind blowing!', rating: 5, video: seven, user: john)
review2 = Review.create(content: 'the best performce of pitt', rating: 4, video: seven, user: john)
