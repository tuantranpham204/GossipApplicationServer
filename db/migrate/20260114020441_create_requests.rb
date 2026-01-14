class CreateRequests < ActiveRecord::Migration[8.1]
  def change
    create_table :requests do |t|
      t.references :sender, null: false, foreign_key: { to_table: :users, to_column: :id }
      t.references :receiver, null: false, foreign_key: { to_table: :users, to_column: :id }
      t.integer :request_type
      t.integer :status
      t.jsonb :data

      t.timestamps
    end
  end
end
