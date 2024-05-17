# frozen_string_literal: true

class Notifications < ApplicationRecord
  belongs_to :user

  validates :content, :readed, presence: true
end
