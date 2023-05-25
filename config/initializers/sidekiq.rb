Sidekiq.configure_server do |config|
  # Add any other server configuration if needed
  
  config.redis = { url: 'redis://localhost:6379/0' } # Configure Redis URL if using Redis as the Sidekiq backend 
end

Sidekiq.configure_client do |config|
  # Add any other client configuration if needed
  
  config.redis = { url: 'redis://localhost:6379/0' } # Configure Redis URL if using Redis as the Sidekiq backend
end