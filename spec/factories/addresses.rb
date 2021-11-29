FactoryBot.define do
  factory :address do
    address{Faker::Address.street_address}
    phone{Faker::PhoneNumber.phone_number}
    user_id{create(:user).id}
  end
end
