# 4.times do |n|
#     name = Faker::Name.name
#     email = "user-#{n}@gmail.com"
#     u = Product.new(
#         name: name,
#         description: email,
#         quantity: rand(2..15),
#         price: Faker::Number.decimal(l_digits: 3, r_digits: 2),
#     )
#     u.images.attach(io: File.open(Rails.root.join("app", "assets", "images", "banh1.jpg")),
#         filename: "banh1.jpg",
#         content_type: "image/jpg")
#     u.save!

# category
10.times do |n|
  name = Faker::Food.ingredient
  Category.create!(name: name)
end

# product
categories = Category.order(:created_at).take(6)
50.times do |n|
  name = Faker::Food.fruits
  price = 500000
  description = Faker::Food.description
  categories.each do |category|
    category.products.create!(name: name,
                              price: price,
                              description: description,
                              quantity: 3)
  end
end


User.all.sample(10).each do |user|
  product = Product.all.sample(2)
  address = user.addresses.sample(1)
  order = user.orders.build(
    address_id: 1,
    total_price: product[0].price)
  order.order_details.build(
    quantity: 2,
    actual_price: product[0].price,
    product_id: product[0].id)
  order.save
end

User.create!(
  email: "phikhanhb7@gmail.com",
  name: "Nguyen Phi Khanh",
  role: 1,
  password: "123456",
  password_confirmation: "123456",
  status: true
)

10.times do |n|
  name = Faker::Name.unique.name
  email = "example-#{n+1}@railstutorial.org"
  password = "123456"
  phone = Faker::PhoneNumber.phone_number
  address = Faker::Address.full_address
  user = User.create!(name: name,
                   email: email,
                   password: password,
                   password_confirmation: password,
                   status: true,
                   role: 0)
  user.addresses.create!(phone: phone,
                      address: address)
end
