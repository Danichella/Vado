# frozen_string_literal: true

class NotificationSerializer
  include JSONAPI::Serializer
  attributes :content, :readed

  attribute :time do |object|
    timezone = object.settings.timezone || 'UTC'
    created_at = object.created_at.in_time_zone(timezone)
    crated_date = created_at.strftime('%Y-%m-%d')

    if crated_date == Time.now.in_time_zone(timezone).strftime('%Y-%m-%d')
      created_at.in_time_zone(timezone).strftime('%H:%M')
    elsif crated_date == Time.yesterday.in_time_zone(timezone).strftime('%Y-%m-%d')
      created_at.strftime('Вчора %H:%M')
    else
      created_at.strftime('%-d %b %H:%M')
    end
  end
end
