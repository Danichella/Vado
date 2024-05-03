# frozen_string_literal: true

class Message < ApplicationRecord
  belongs_to :chat

  validates :text, presence: true
end
