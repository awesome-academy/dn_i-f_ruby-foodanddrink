FactoryBot.define do
  factory :order_detail do
    quantity { 3 }
    actual_price { 100000 }
    order_id { create(:order).id }
    product_id { create(:product).id }
  end
end
