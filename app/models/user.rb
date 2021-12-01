class User < ApplicationRecord
  has_secure_password
  has_many :addresses, dependent: :destroy
  has_many :orders, dependent: :destroy
<<<<<<< HEAD
  has_secure_password
=======
>>>>>>> 456f310 (login)
end
