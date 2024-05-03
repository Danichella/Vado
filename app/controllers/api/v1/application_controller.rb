# frozen_string_literal: true

class Api::V1::ApplicationController < ApplicationController
  before_action :authenticate_user!

  def render_serializable_json(data, options = {})
    serializer = options.fetch(:serializer)
    params = options.fetch(:params, {})
    status = options.fetch(:status, nil)

    render json: serializer.new(data, params:).serializable_hash, status:
  end

  def render_error(status, message)
    render json: { error: { status:, message: } }, status:
  end
end
