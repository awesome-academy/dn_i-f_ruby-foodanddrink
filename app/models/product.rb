class Product < ApplicationRecord
  belongs_to :category
  has_one_attached :images

  has_many :order_details, dependent: :destroy
  has_many :orders, through: :order_details

  scope :recent, ->{order updated_at: :DESC}
end
