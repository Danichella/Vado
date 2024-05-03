class CreateChats < ActiveRecord::Migration[7.1]
  def change
    create_table :chats do |t|
      t.string :title, default: 'New chat', null: false

      t.timestamps
    end

    add_reference :chats, :user, foreign_key: true
  end
end
