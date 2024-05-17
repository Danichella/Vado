# frozen_string_literal: true

class Notification < ApplicationRecord
  belongs_to :user

  validates :content, presence: true
end
