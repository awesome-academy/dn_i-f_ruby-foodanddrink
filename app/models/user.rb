class User < ApplicationRecord
  has_many :addresses, dependent: :destroy
  has_many :orders, dependent: :destroy

  has_secure_password

  enum role: {
    admin: 1,
    user: 0
  }
end
