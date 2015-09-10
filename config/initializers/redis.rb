namespace = AppConfig['redis_namespace']

# Configure direct link
REDIS = Redis.new(url: "redis://localhost:6379/0/#{namespace}")
