class User < ApplicationRecord
  has_many :addresses, dependent: :destroy
  has_many :orders, dependent: :destroy

  has_secure_password

  before_save :downcase_email

  validates :name, presence: true, length: {maximum: Settings.length_50}
  validates :email, uniqueness: true, length: {maximum: Settings.length_50}
  validates :password, presence: true, length: {minimum: Settings.length_6},
  allow_nil: true

  private
  def downcase_email
    email.downcase!
  end
end
