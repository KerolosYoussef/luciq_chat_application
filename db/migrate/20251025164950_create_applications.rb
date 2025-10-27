class CreateApplications < ActiveRecord::Migration[8.1]
  def change
    create_table :applications do |t|
      t.string :token
      t.string :name
      t.integer :chats_count, null: false, default: 0

      t.timestamps
    end

    add_index :applications, :token, unique: true
  end
end
