begin
  require 'warden/jwt_auth'

  user = User.find_or_create_by!(email: 'debug_auth@example.com') do |u|
    u.password = 'Password123!'
    u.username = 'debug_auth'
    u.first_name = 'Debug'
    u.last_name = 'Auth'
    u.dob = Date.new(2000, 1, 1)
    u.gender = 1
    u.confirmed_at = Time.now
  end

  # Ensure profile exists
  Profile.find_or_create_by!(user_id: user.id) do |p|
    p.first_name = user.first_name
    p.last_name = user.last_name
    p.gender = "male"
    p.relationship_status = "single"
  end

  token = Warden::JWTAuth::UserEncoder.new.call(user, :user, nil).first
  puts "USER_ID: #{user.id}"
  puts "TOKEN: #{token}"
rescue => e
  puts "ERROR: #{e.message}"
  puts e.backtrace
end
