require 'net/http'
require 'uri'
require 'json'

def test_login(email, password)
  uri = URI.parse("http://localhost:3000/api/v1/users/sign_in")
  http = Net::HTTP.new(uri.host, uri.port)
  request = Net::HTTP::Post.new(uri.path, {'Content-Type' => 'application/json', 'Accept' => '*/*'}) # Changed to */* to mimic browser/weak client
  request.body = { user: { email_or_username: email, password: password } }.to_json

  begin
    response = http.request(request)
    puts "Status: #{response.code}"
    puts "Body: #{response.body}"
  rescue Errno::ECONNREFUSED
    puts "Connection refused. Is the server running?"
  rescue => e
    puts "Error: #{e.message}"
  end
end

puts "Testing with invalid credentials..."
test_login("nonexistent@example.com", "wrongpassword")
