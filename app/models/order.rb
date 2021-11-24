class Order < ApplicationRecord
  belongs_to :user
  belongs_to :address

  has_many :order_details, dependent: :destroy
  has_many :products, through: :order_details
end
