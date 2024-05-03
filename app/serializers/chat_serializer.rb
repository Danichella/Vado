class ChatSerializer
  include JSONAPI::Serializer
  attributes :id, :title, :created_at, :updated_at
end
