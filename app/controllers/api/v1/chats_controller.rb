# frozen_string_literal: true

class Api::V1::ChatsController < Api::V1::ApplicationController
  before_action :find_chat, only: [:show, :update, :destroy]

  def index
    chats = current_user.chats

    render_serializable_json(
      chats, { status: :ok }
    )
  end

  def show
    render_serializable_json(
      @chat, { status: :ok }
    )
  end

  def create
    chat = current_user.chats.new(chat_params)

    if chat.save
      render_serializable_json(
        chat, { status: :created }
      )
    else
      render_error(422, chat.errors.full_messages.to_sentence)
    end
  end

  def update
    if @chat.update(chat_params)
      render_serializable_json(
        @chat, {
          status: :ok
        }
      )
    else
      render_error(422, @chat.errors.full_messages.to_sentence)
    end
  end

  def destroy
    if @chat.destroy
      render_serializable_json(
        @chat, {
          status: :deleted
        }
      )
    else
      render_error(422, @chat.errors.full_messages.to_sentence)
    end
  end

  private

  def find_chat
    @chat = current_user.chats.find_by(id: params[:id])

    render_not_found_error and return unless @chat
  end

  def chat_params
    params.permit(:title)
  end

  def render_not_found_error
    render_error(404, 'Chat not found')
  end

  def render_serializable_json(data, options)
    options[:serializer] = ChatSerializer

    super(data, options)
  end
end
