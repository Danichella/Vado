# frozen_string_literal: true

class MessageSerializer
  include JSONAPI::Serializer
  attributes :id, :text, :response, :created_at, :updated_at
end
