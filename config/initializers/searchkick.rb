Searchkick.client_options = {
  url: ENV.fetch('ELASTICSEARCH_URL', 'http://elasticsearch:9200'),
  retry_on_failure: true,
  transport_options: { request: { timeout: 30 } }
}