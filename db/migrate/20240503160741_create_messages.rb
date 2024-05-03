class CreateMessages < ActiveRecord::Migration[7.1]
  def change
    create_table :messages do |t|
      t.text :text, null: false
      t.text :response

      t.timestamps
    end

    add_reference :messages, :chat, foreign_key: true
  end
end
