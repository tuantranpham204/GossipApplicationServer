class CreateUserRelations < ActiveRecord::Migration[8.1]
  def change
    create_table :user_relations, id: false do |t|
      t.references :requester, null: false, foreign_key: true
      t.references :receiver, null: false, foreign_key: true
      t.integer :status, null: false
      t.integer :relation_type, null: false

      t.timestamps
    end
  end
end
