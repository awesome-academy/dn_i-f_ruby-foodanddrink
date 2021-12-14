FactoryBot.define do
  factory :order do
    total_price{ 100000 }
    status{ 0 }
    address_id{ create(:address).id }
    user_id{ create(:user).id }
  end
end
