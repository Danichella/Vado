# frozen_string_literal: true

class MessageSerializer
  include JSONAPI::Serializer
  attributes :content, :role, :created_at, :updated_at
end
