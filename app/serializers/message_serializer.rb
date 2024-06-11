# frozen_string_literal: true

class MessageSerializer
  include JSONAPI::Serializer
  attributes :content, :role, :created_at

  attribute :time do |object|
    object.created_at.in_time_zone(object.settings.timezone).strftime('%H:%M')
  end
end
