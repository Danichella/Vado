# frozen_string_literal: true

class SettingsSerializer
  include JSONAPI::Serializer
  attributes :timezone, :location
end
