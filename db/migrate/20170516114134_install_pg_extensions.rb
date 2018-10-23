class InstallPgExtensions < ActiveRecord::Migration[5.1]
  def up
    execute "CREATE EXTENSION IF NOT EXISTS citext;"
    execute "CREATE EXTENSION IF NOT EXISTS hstore;"
    execute "CREATE EXTENSION IF NOT EXISTS pg_trgm;"
    execute "CREATE EXTENSION IF NOT EXISTS fuzzystrmatch;"
    execute "CREATE EXTENSION IF NOT EXISTS unaccent;"
    execute 'CREATE EXTENSION IF NOT EXISTS "uuid-ossp"'
    execute 'CREATE EXTENSION IF NOT EXISTS "pgcrypto"'
  end

  def down
    execute "DROP EXTENSION IF EXISTS citext;"
    execute "DROP EXTENSION IF EXISTS hstore;"
    execute "DROP EXTENSION IF EXISTS pg_trgm;"
    execute "DROP EXTENSION IF EXISTS fuzzystrmatch;"
    execute "DROP EXTENSION IF EXISTS unaccent;"
    execute "DROP EXTENSION IF EXISTS 'uuid-ossp'"
    execute "DROP EXTENSION IF EXISTS 'pgcrypto'"
  end
end
