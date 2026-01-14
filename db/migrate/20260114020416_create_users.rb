class CreateUsers < ActiveRecord::Migration[8.1]
  def change
    create_table :users do |t|
      t.string :username, null: false
      t.string :email, null: false
      t.string :password_digest, null: false
      t.string :confirmation_token
      t.datetime :confirmed_at
      t.datetime :username_last_changed_at

      t.timestamps
    end
    add_index :users, :username
    add_index :users, :email
  end
end
