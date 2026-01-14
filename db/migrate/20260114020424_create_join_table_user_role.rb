class CreateJoinTableUserRole < ActiveRecord::Migration[8.1]
  def change
    create_table :user_role, id: false do |t|
      t.references :user, null: false, foreign_key: { to_table: :users, to_column: :id }
      t.references :role, null: false, foreign_key: { to_table: :roles, to_column: :id }

      t.index [ :user_id, :role_id ], unique: true, name: 'pk_user_roles'
      t.index [ :role_id, :user_id ]
    end
    execute "ALTER TABLE user_role ADD PRIMARY KEY (user_id, role_id);"
  end
end
