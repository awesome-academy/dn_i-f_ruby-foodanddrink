FactoryBot.define do
  factory :user do
    name{Faker::Name.name_with_middle}
    email{Faker::Internet.email}
    password{"123456"}
    password_confirmation{"123456"}
  end
end
