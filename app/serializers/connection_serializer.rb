# frozen_string_literal: true

class ConnectionSerializer
  include JSONAPI::Serializer
  attributes :provider

  attribute :connected, &:connected?
end
