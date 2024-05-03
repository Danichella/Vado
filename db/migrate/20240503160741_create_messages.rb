# frozen_string_literal: true

class CreateMessages < ActiveRecord::Migration[7.1]
  def change
    create_table :messages, id: :uuid do |t|
      t.text :text, null: false
      t.text :response

      t.timestamps
    end

    add_reference :messages, :chat, type: :uuid, foreign_key: true
  end
end
