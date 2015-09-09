namespace = AppConfig['redis_namespace']

# Configure app cache
Rails.application.config.cache_store = :redis_store, "redis://localhost:6379/0/#{namespace}-cache", { expires_in: 90.minutes }

# Configure direct link
REDIS = Redis.new(url: "redis://localhost:6379/0/#{namespace}")
