# frozen_string_literal: true

class CreateConnections < ActiveRecord::Migration[7.1]
  def change
    create_table :connections do |t|
      t.integer :provider, null: false
      t.string :access_token, null: false
      t.string :refresh_token, null: false
      t.datetime :expires_in, null: false

      t.timestamps
    end

    add_reference :connections, :user, foreign_key: true
  end
end
