class Product < ApplicationRecord
  belongs_to :category
  has_one_attached :image
  has_many :order_details, dependent: :destroy
  has_many :orders, through: :order_details

  accepts_nested_attributes_for :category, allow_destroy: true

  scope :recent, ->{order created_at: :DESC}
  delegate :name, to: :category, prefix: true

  validates :name, presence: true,
    length: {
      minimum: Settings.length.min_6,
      maximum: Settings.length.max_100
    }

  validates :price, presence: true,
                    numericality:
                    {
                      only_integer: false,
                      greater_than_or_equal_to: Settings.check_number
                    }

  validates :description, presence: true,
    length: {
      minimum: Settings.length.min_6,
      maximum: Settings.length.max_300
    }

  validates :quantity, presence: true,
                       numericality:
                       {
                         only_integer: true,
                         greater_than_or_equal_to: Settings.check_number
                       }

  validates :image,
            content_type:
            {
              in: Settings.image.format,
              message: I18n.t("valid_image.format")
            },
            size:
            {
              less_than: Settings.image.size_3mb.megabytes,
              message: I18n.t("valid_image.size")
            }

  def display_image
    image.variant(resize: "300x300!").processed
  end
end
