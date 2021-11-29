class Order < ApplicationRecord
  belongs_to :user
  belongs_to :address
  has_many :order_details, dependent: :destroy
  has_many :products, through: :order_details
  enum status: {
    open: 0,
    confirmed: 1,
    cancelled: 2
  }

  scope :recent_orders, ->{order created_at: :desc}
  delegate :name, to: :user, prefix: true
  delegate :phone, :address, to: :address, prefix: true
end
