# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end


admin = User.create!(
  username: "urfavadmin",
  email: "admin@example.com",
  password: "password",
  password_confirmation: "password",
  created_at: Time.now,
  updated_at: Time.now,
  confirmed_at: Time.now
)
admin.roles << User::ROLES[:ADMIN]

20.times do |i|
  User.create!(
    username: "urfavuser#{i+1}",
    email: "user#{i+1}@example.com",
    password: "password",
    password_confirmation: "password",
    created_at: Time.now,
    updated_at: Time.now,
    confirmed_at: Time.now
  )
end
