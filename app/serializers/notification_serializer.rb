# frozen_string_literal: true

class NotificationSerializer
  include JSONAPI::Serializer
  attributes :content, :readed

  attribute :time do |object|
    created_at = object.created_at
    crated_date = created_at.strftime('%Y-%m-%d')

    if crated_date == Time.zone.now.strftime('%Y-%m-%d')
      created_at.strftime('%H:%M')
    elsif crated_date == Time.zone.yesterday.strftime('%Y-%m-%d')
      created_at.strftime('Вчора %H:%M')
    else
      created_at.strftime('%-d %b %H:%M')
    end
  end
end
