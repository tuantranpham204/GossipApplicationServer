# verify_user_login.rb
require 'net/http'
require 'uri'
require 'json'

# Part 1: Check Database via Rails Runner (Logic Check)
begin
  user = User.find_by(username: "tuantop1") || User.find_by(email: "12a1tranphamtuan69@gmail.com")
  
  if user
    puts "User found: #{user.username} (#{user.email})"
    
    # Check password 'string'
    if user.valid_password?("string")
      puts "Password matches."
      
      # Part 2: Check API (Server Configuration Check)
      uri = URI.parse("http://localhost:3000/api/v1/users/sign_in")
      http = Net::HTTP.new(uri.host, uri.port)
      request = Net::HTTP::Post.new(uri.path, {
        'Content-Type' => 'application/json',
        'Accept' => 'application/json'
      })
      
      # We send 'email' key because we suspect stale config uses that key,
      # but verify that our Hotfix handles it correctly.
      request.body = {
        user: {
          email: "tuantop1", # Username in email field
          password: "string"
        }
      }.to_json

      puts "Attempting API login with USERNAME in EMAIL field..."
      response = http.request(request)
      puts "API Response Code: #{response.code}"
      puts "API Response Body: #{response.body}"

      # Also try email in email field
      request.body = {
        user: {
          email: "12a1tranphamtuan69@gmail.com",
          password: "string"
        }
      }.to_json
      puts "Attempting API login with EMAIL in EMAIL field..."
      response = http.request(request)
      puts "API Response Code: #{response.code}"
      puts "API Response Body: #{response.body}"

    else
      puts "Password 'string' does NOT match."
    end
  else
    puts "User 'tuantop1' not found in database."
  end
rescue => e
  puts "Error: #{e.message}"
end
