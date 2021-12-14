FactoryBot.define do
  factory :category do
    name{ Faker::Food.ingredient }
  end
end
