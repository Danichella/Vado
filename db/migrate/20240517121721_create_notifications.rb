class CreateNotifications < ActiveRecord::Migration[7.1]
  def change
    create_table :notifications do |t|
      t.text :content, null: false
      t.boolean :readed, default: false, null: false

      t.timestamps
    end

    add_reference :notifications, :user, foreign_key: true
  end
end
