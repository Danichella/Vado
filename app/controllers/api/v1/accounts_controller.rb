# frozen_string_literal: true

class Api::V1::AccountsController < Api::V1::ApplicationController
  def current
    render_serializable_json(
      current_user, { serializer: UserSerializer, status: :ok }
    )
  end
end
