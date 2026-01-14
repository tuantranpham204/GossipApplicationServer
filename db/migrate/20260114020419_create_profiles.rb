class CreateProfiles < ActiveRecord::Migration[8.1]
  def change
    create_table :profiles, id: false do |t|
      t.belongs_to :user, primary_key: true, foreign_key: { on_delete: :cascade }
      t.string :full_name, null: false
      t.string :bio
      t.integer :gender, null: false
      t.integer :relationship_status, null: false
      t.integer :status, null: false
      t.jsonb :avatar_data

      # Privacy setting attributes
      t.boolean :allow_direct_follows, null: false
      t.boolean :is_email_public, null: false
      t.boolean :is_gender_public, null: false
      t.boolean :is_rel_status_public, null: false

      t.timestamps
    end
  end
end
