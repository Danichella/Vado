# frozen_string_literal: true

class CreateMessages < ActiveRecord::Migration[7.1]
  def change
    create_table :messages, id: :uuid do |t|
      t.string :role, null: false
      t.text :content, null: false
      t.string :tool_call_id
      t.string :tool_name

      t.timestamps
    end

    add_reference :messages, :chat, type: :uuid, foreign_key: true
  end
end
