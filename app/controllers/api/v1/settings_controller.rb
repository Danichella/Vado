# frozen_string_literal: true

class Api::V1::SettingsController < Api::V1::ApplicationController
  before_action :find_settings, only: :update

  def show
    render_serializable_json(
      current_user.settings, { status: :ok }
    )
  end

  def update
    if @settings.update(settings_params)
      render_serializable_json(
        @settings.reload, {
          status: :ok
        }
      )
    else
      render_error(422, @settings.errors.full_messages.to_sentence)
    end
  end

  private

  def find_settings
    @settings = current_user.settings

    render_error(404, 'Settings not found') and return unless @settings
  end

  def settings_params
    params.permit(:timezone, :location)
  end

  def render_serializable_json(data, options)
    options[:serializer] = SettingsSerializer

    super(data, options)
  end
end
