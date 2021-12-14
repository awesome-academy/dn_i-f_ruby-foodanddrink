class User < ApplicationRecord
  has_many :addresses, dependent: :destroy
  has_many :orders, dependent: :destroy

  has_secure_password

  enum role: {
    admin: 1,
    user: 0
  }

  validates :name, presence: true, length:
    {
      minimum: Settings.length.min_6,
      maximum: Settings.length.max_100
    }

  validates :email, presence: true, uniqueness: true,
    length: {maximum: Settings.length.max_100},
    format: {with: URI::MailTo::EMAIL_REGEXP}

  validates :password, presence: true, length:
    {
      minimum: Settings.length.min_6,
      maximum: Settings.length.max_100
    }
end
