FactoryBot.define do
  factory :product do
    name { Faker::Name.name }
    price { 50000 }
    description {Faker::Food.description}
    quantity { 10 }
    category_id {create(:category).id}
  end
end
