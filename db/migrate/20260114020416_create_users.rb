class CreateUsers < ActiveRecord::Migration[8.1]
  def change
    create_table :users do |t|
      t.string :username, null: false
      t.string :email, null: false
      t.integer :roles, array: true, default: [ 1 ]
      t.datetime :username_last_changed_at

      t.timestamps
    end
    add_index :users, :username
    add_index :users, :email
  end
end
