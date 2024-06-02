# frozen_string_literal: true

class Connection < ApplicationRecord
  belongs_to :user

  validates :provider, :access_token, :expires_in, :refresh_token, presence: true
  validates :provider, uniqueness: { scope: :user_id }

  enum provider: { google_calendar: 0 }

  def connected?
    access_token.present? && refresh_token.present?
  end
end
