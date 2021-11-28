# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
4.times do |n|
    name = Faker::Name.name
    email = "user-#{n}@gmail.com"
    u = Product.new(
        name: name,
        description: email,
        quantity: rand(2..15),
        price: Faker::Number.decimal(l_digits: 3, r_digits: 2),
    )
    u.images.attach(io: File.open(Rails.root.join("app", "assets", "images", "banh1.jpg")),
        filename: "banh1.jpg",
        content_type: "image/jpg")
    u.save!
end
