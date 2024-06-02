# frozen_string_literal: true

class Api::V1::ConnectionsController < Api::V1::ApplicationController
  before_action :find_connection, only: [:destroy]

  def index
    connections = current_user.connections

    render_serializable_json(
      connections, { status: :ok }
    )
  end

  def destroy
    if @connection.destroy
      render_serializable_json(
        @connection, {
          status: :deleted
        }
      )
    else
      render_error(422, @connection.errors.full_messages.to_sentence)
    end
  end

  private

  def find_connection
    @connection = current_user.connections.find_by(id: params[:id])

    render_error(404, 'Connection not found') and return unless @connection
  end

  def render_serializable_json(data, options)
    options[:serializer] = ConnectionSerializer

    super(data, options)
  end
end
