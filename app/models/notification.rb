# frozen_string_literal: true

class Notification < ApplicationRecord
  belongs_to :user
  has_one :settings, through: :users

  validates :content, presence: true
end
