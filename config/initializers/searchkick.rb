Searchkick.redis = ConnectionPool.new { Redis.new() }
# Searchkick::ProcessQueueJob.perform_later(class_name: 'ContentUnit')