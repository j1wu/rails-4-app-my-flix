# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

drama = Category.create(name: 'Drama')
scifi = Category.create(name: 'Sci-Fi')

Video.create(title: 'Annie Hall', description: 'N/A', small_cover_url: '/tmp/annie_hall.jpg', large_cover_url: '/tmp/sample.jpg', category: drama)
Video.create(title: 'Avengers', description: 'N/A', small_cover_url: '/tmp/avengers.jpg', large_cover_url: '/tmp/sample.jpg', category: scifi)
Video.create(title: 'Dark Night', description: 'N/A', small_cover_url: '/tmp/dark_knight.jpg', large_cover_url: '/tmp/sample.jpg', category: scifi)
Video.create(title: 'Godfather', description: 'N/A', small_cover_url: '/tmp/godfather.jpg', large_cover_url: '/tmp/sample.jpg', category: drama)