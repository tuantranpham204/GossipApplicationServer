class CreateNotifications < ActiveRecord::Migration[8.1]
  def change
    create_table :notifications do |t|
      t.references :recipient, null: false, foreign_key: { to_table: :users, to_column: :id }
      t.references :actor, null: false, foreign_key: { to_table: :users, to_column: :id }
      t.integer :notifiable_type
      t.bigint :notifiable_id
      t.boolean :is_read

      t.timestamps
    end
  end
end
