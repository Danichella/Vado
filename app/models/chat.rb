# frozen_string_literal: true

class Chat < ApplicationRecord
  belongs_to :user

  has_many :messages, -> { order(created_at: :asc) }, dependent: :destroy
end
