# frozen_string_literal: true

class Api::V1::NotificationsController < Api::V1::ApplicationController
  before_action :find_notification, only: [:destroy, :readed]

  def index
    notifications = current_user.notifications.order(created_at: :desc).limit(20)

    render_serializable_json(
      notifications, { status: :ok }
    )
  end

  def readed
    if @notification.update(readed: true)
      render_serializable_json(
        @notification.reload, {
          status: :ok
        }
      )
    else
      render_error(422, @notification.errors.full_messages.to_sentence)
    end
  end

  def destroy
    if @notification.destroy
      render_serializable_json(
        @notification, {
          status: :deleted
        }
      )
    else
      render_error(422, @notification.errors.full_messages.to_sentence)
    end
  end

  private

  def find_notification
    @notification = current_user.notifications.find_by(id: params[:id])

    render_error(404, 'Notification not found') and return unless @notification
  end

  def render_serializable_json(data, options)
    options[:serializer] = NotificationSerializer

    super(data, options)
  end
end
