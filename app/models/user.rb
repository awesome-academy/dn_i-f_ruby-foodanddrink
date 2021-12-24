class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :omniauthable, omniauth_providers: [:facebook, :google_oauth2]

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

  class << self
    def from_omniauth auth
      result = User.find_by email: auth.info.email
      return result if result

      where(provider: auth.provider, uid: auth.uid).first_or_create do |user|
        user.email = auth.info.email
        user.password = Devise.friendly_token[0, 20]
        user.name = auth.info.name
        user.uid = auth.uid
        user.provider = auth.provider
      end
    end
  end
end
