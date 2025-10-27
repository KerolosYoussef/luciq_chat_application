# Ensure Elasticsearch indices are created on startup
Rails.application.config.after_initialize do
  if defined?(Searchkick)
    begin
      # Create index if it doesn't exist
      unless Message.search_index.exists?
        Rails.logger.info "Creating Elasticsearch index for Message..."
        Message.reindex
        Rails.logger.info "Elasticsearch index created successfully"
      else
        Rails.logger.info "Elasticsearch index for Message already exists"
      end
    rescue => e
      Rails.logger.error "Could not create Elasticsearch index: #{e.message}"
      Rails.logger.error e.backtrace.join("\n")
    end
  end
end
