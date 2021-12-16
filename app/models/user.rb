class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :addresses, dependent: :destroy
  has_many :orders, dependent: :destroy

  enum role: {
    admin: 1,
    user: 0
  }

  validates :name, presence: true, length:
    {
      minimum: Settings.length.min_6,
      maximum: Settings.length.max_100
    }
end
