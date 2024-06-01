# frozen_string_literal: true

class User < ApplicationRecord
  include Devise::JWT::RevocationStrategies::JTIMatcher

  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :jwt_authenticatable, :omniauthable,
         jwt_revocation_strategy: self, omniauth_providers: %i[google_oauth2]

  has_one :settings, dependent: :destroy
  has_many :chats, dependent: :destroy
  has_many :messages, through: :chats
  has_many :notifications, dependent: :destroy

  after_create ->(user) { Settings.create(user_id: user.id) }

  def self.from_omniauth(access_token)
    data = access_token.info
    user = User.find_by(email: data['email'])

    # Uncomment the section below if you want users to be created if they don't exist
    user ||= User.create(
      email: data['email'],
      password: Devise.friendly_token[0, 20]
    )
    user
  end
end
