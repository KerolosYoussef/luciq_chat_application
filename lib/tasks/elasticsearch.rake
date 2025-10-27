# lib/tasks/elasticsearch.rake

namespace :elasticsearch do
  desc "Setup Elasticsearch indices"
  task setup: :environment do
    puts "Setting up Elasticsearch indices..."

    begin
      max_retries = 30
      retry_count = 0

      loop do
        begin
          Searchkick.client.cluster.health
          puts "Elasticsearch is ready"
          break
        rescue => e
          retry_count += 1
          if retry_count >= max_retries
            puts "Elasticsearch not available after #{max_retries} attempts"
            exit 1
          end
          puts "Waiting for Elasticsearch... (#{retry_count}/#{max_retries})"
          sleep 1
        end
      end

      puts "Creating Message index..."
      Message.reindex

      puts "Elasticsearch setup complete!"
    rescue => e
      puts "Failed to setup Elasticsearch: #{e.message}"
      puts e.backtrace.first(10).join("\n")
      exit 1
    end
  end
end