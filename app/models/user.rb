class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :omniauthable, :database_authenticatable, omniauth_providers: [:google_oauth2]
  has_many :tasks

  def self.from_omniauth(access_token)
    data = access_token.info
    user = User.where(email: data['email']).first

    user ||= User.create(
      name: data['email'].split('@')[0].capitalize,
      email: data['email'],
      encrypted_password: Devise.friendly_token[0, 20]
    )
    user
  end
end
