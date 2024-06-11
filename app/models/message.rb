# frozen_string_literal: true

class Message < ApplicationRecord
  belongs_to :chat
  has_one :users, through: :chat
  has_one :settings, through: :users

  validates :role, :content, presence: true
end
