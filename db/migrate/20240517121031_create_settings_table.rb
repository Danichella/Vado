class CreateSettingsTable < ActiveRecord::Migration[7.1]
  def change
    create_table :settings do |t|
      t.string :timezone
      t.json :location

      t.timestamps
    end

    add_reference :settings, :user, foreign_key: true, index: {unique: true}
  end
end
