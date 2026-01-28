

Searchkick.client = Rails.env.production? ? Elasticsearch::Client.new(
  url: ENV.fetch("ELASTICSEARCH_CLOUD_URL"),
  transport_options: {
    headers: {
      "Authorization" => "ApiKey #{ENV.fetch('ELASTICSEARCH_API_KEY')}"
    }
  }
) : Elasticsearch::Client.new(
  url: ENV.fetch("ELASTICSEARCH_LOCAL_URL")
)
