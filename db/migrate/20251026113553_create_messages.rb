class CreateMessages < ActiveRecord::Migration[8.1]
  def change
    create_table :messages do |t|
      t.references :chat, null: false, foreign_key: true
      t.integer :number, default: 0, null: false
      t.string :body

      t.timestamps
    end

    add_index :messages, [:chat_id, :number], unique: true
  end
end
