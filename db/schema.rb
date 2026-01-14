# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[8.1].define(version: 2026_01_14_020443) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "pg_catalog.plpgsql"

  create_table "follows", primary_key: ["requester_id", "receiver_id"], force: :cascade do |t|
    t.datetime "created_at", null: false
    t.bigint "receiver_id", null: false
    t.bigint "requester_id", null: false
    t.integer "status", null: false
    t.datetime "updated_at", null: false
    t.index ["receiver_id"], name: "index_follows_on_receiver_id"
    t.index ["requester_id"], name: "index_follows_on_requester_id"
  end

  create_table "friendships", primary_key: ["requester_id", "receiver_id"], force: :cascade do |t|
    t.datetime "created_at", null: false
    t.bigint "receiver_id", null: false
    t.bigint "requester_id", null: false
    t.integer "status"
    t.datetime "updated_at", null: false
    t.index ["receiver_id"], name: "index_friendships_on_receiver_id"
    t.index ["requester_id"], name: "index_friendships_on_requester_id"
  end

  create_table "messages", force: :cascade do |t|
    t.jsonb "attachment_data"
    t.text "content"
    t.datetime "created_at", null: false
    t.boolean "is_deleted"
    t.integer "message_type"
    t.bigint "room_id", null: false
    t.bigint "sender_id", null: false
    t.datetime "updated_at", null: false
    t.index ["room_id"], name: "index_messages_on_room_id"
    t.index ["sender_id"], name: "index_messages_on_sender_id"
  end

  create_table "notifications", force: :cascade do |t|
    t.bigint "actor_id", null: false
    t.datetime "created_at", null: false
    t.boolean "is_read"
    t.bigint "notifiable_id"
    t.integer "notifiable_type"
    t.bigint "recipient_id", null: false
    t.datetime "updated_at", null: false
    t.index ["actor_id"], name: "index_notifications_on_actor_id"
    t.index ["recipient_id"], name: "index_notifications_on_recipient_id"
  end

  create_table "participants", primary_key: ["user_id", "room_id"], force: :cascade do |t|
    t.datetime "created_at", null: false
    t.boolean "is_approved", null: false
    t.datetime "last_read_at"
    t.integer "role", null: false
    t.bigint "room_id", null: false
    t.datetime "updated_at", null: false
    t.bigint "user_id", null: false
    t.index ["room_id"], name: "index_participants_on_room_id"
    t.index ["user_id"], name: "index_participants_on_user_id"
  end

  create_table "profiles", primary_key: "user_id", force: :cascade do |t|
    t.boolean "allow_direct_follows", null: false
    t.jsonb "avatar_data"
    t.string "bio"
    t.datetime "created_at", null: false
    t.string "full_name", null: false
    t.integer "gender", null: false
    t.boolean "is_email_public", null: false
    t.boolean "is_gender_public", null: false
    t.boolean "is_rel_status_public", null: false
    t.integer "relationship_status", null: false
    t.integer "status", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_profiles_on_user_id"
  end

  create_table "requests", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.jsonb "data"
    t.bigint "receiver_id", null: false
    t.integer "request_type"
    t.bigint "sender_id", null: false
    t.integer "status"
    t.datetime "updated_at", null: false
    t.index ["receiver_id"], name: "index_requests_on_receiver_id"
    t.index ["sender_id"], name: "index_requests_on_sender_id"
  end

  create_table "roles", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "role_name"
    t.datetime "updated_at", null: false
    t.index ["role_name"], name: "index_roles_on_role_name"
  end

  create_table "roles_users", id: false, force: :cascade do |t|
    t.bigint "role_id", null: false
    t.bigint "user_id", null: false
    t.index ["role_id", "user_id"], name: "index_roles_users_on_role_id_and_user_id"
    t.index ["user_id", "role_id"], name: "pk_user_roles", unique: true
  end

  create_table "rooms", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.jsonb "metadata"
    t.string "name"
    t.integer "room_type", null: false
    t.datetime "updated_at", null: false
  end

  create_table "users", force: :cascade do |t|
    t.string "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "created_at", null: false
    t.string "email", null: false
    t.string "password_digest", null: false
    t.datetime "updated_at", null: false
    t.string "username", null: false
    t.datetime "username_last_changed_at"
    t.index ["email"], name: "index_users_on_email"
    t.index ["username"], name: "index_users_on_username"
  end

  add_foreign_key "follows", "users", column: "receiver_id"
  add_foreign_key "follows", "users", column: "requester_id"
  add_foreign_key "friendships", "users", column: "receiver_id"
  add_foreign_key "friendships", "users", column: "requester_id"
  add_foreign_key "messages", "rooms"
  add_foreign_key "messages", "users", column: "sender_id"
  add_foreign_key "notifications", "users", column: "actor_id"
  add_foreign_key "notifications", "users", column: "recipient_id"
  add_foreign_key "participants", "rooms"
  add_foreign_key "participants", "users"
  add_foreign_key "profiles", "users", on_delete: :cascade
  add_foreign_key "requests", "users", column: "receiver_id"
  add_foreign_key "requests", "users", column: "sender_id"
end
