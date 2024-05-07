# frozen_string_literal: true

class CreateChats < ActiveRecord::Migration[7.1]
  def change
    create_table :chats, id: :uuid do |t|
      t.timestamps
    end

    add_reference :chats, :user, foreign_key: true
  end
end
