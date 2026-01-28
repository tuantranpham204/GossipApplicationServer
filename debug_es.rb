require 'elasticsearch'
client = Elasticsearch::Client.new(url: 'http://elastic:changeme@localhost:9200', log: true)
begin
  puts client.info
rescue => e
  puts "ERROR: #{e.class} - #{e.message}"
end
