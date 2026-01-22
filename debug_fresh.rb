# debug_fresh.rb
require 'net/http'
require 'uri'
require 'json'

puts "=== DIAGNOSTIC START ==="

# 1. Config Check
puts "1. Devise Keys: #{Devise.authentication_keys.inspect}"

# 2. Setup Test User
user = User.find_or_initialize_by(email: "test_fresh@example.com")
user.username = "test_fresh"
user.password = "password123"
user.password_confirmation = "password123"
user.confirmed_at = Time.now
user.save!
puts "2. Test User: #{user.username} (Valid password: 'password123')"

# 3. Model Lookup Test (Simulate Devise)
puts "3. Testing User.find_for_database_authentication..."
conditions = { email_or_username: "test_fresh" }
found_user = User.find_for_database_authentication(conditions)
if found_user
  puts "   [SUCCESS] Found user: #{found_user.username}"
  puts "   [CHECK] Valid password? #{found_user.valid_password?('password123')}"
else
  puts "   [FAILURE] Could not find user with conditions: #{conditions.inspect}"
end

# 4. API Test
token_url = "http://localhost:3000/api/v1/users/sign_in"
uri = URI.parse(token_url)
http = Net::HTTP.new(uri.host, uri.port)
request = Net::HTTP::Post.new(uri.path, {
  'Content-Type' => 'application/json',
  'Accept' => 'application/json'
})
request.body = {
  user: {
    email_or_username: "test_fresh",
    password: "password123"
  }
}.to_json

puts "4. API Response (Target: #{token_url})..."
begin
  response = http.request(request)
  puts "   Code: #{response.code}"
  puts "   Body: #{response.body}"
rescue => e
  puts "   [ERROR] Connection failed: #{e.message}"
end

puts "=== DIAGNOSTIC END ==="
