user = User.new(
  username: 'debugtest_' + Time.now.to_i.to_s,
  email: "debug_#{Time.now.to_i}@example.com",
  password: 'Password123!',
  first_name: 'Debug',
  last_name: 'Test',
  gender: 'male', # Using string based on enum usually works or integer
  dob: '2000-01-01'
)
user.profile_attributes = {
  first_name: 'Debug',
  last_name: 'Test',
  gender: 'male',
  dob: '2000-01-01'
}

if user.save
  puts "User saved successfully. ID: #{user.id}"
else
  puts "User save failed: #{user.errors.full_messages}"
end
