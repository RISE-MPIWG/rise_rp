# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2017_09_18_133646) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "citext"
  enable_extension "fuzzystrmatch"
  enable_extension "hstore"
  enable_extension "pg_trgm"
  enable_extension "pgcrypto"
  enable_extension "plpgsql"
  enable_extension "unaccent"
  enable_extension "uuid-ossp"

  create_table "collections", force: :cascade do |t|
    t.uuid "uuid", default: -> { "uuid_generate_v4()" }, null: false
    t.string "name"
    t.jsonb "metadata", default: "{}", null: false
    t.integer "import_type", default: 0
    t.string "import_folder"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["import_type"], name: "index_collections_on_import_type"
    t.index ["metadata"], name: "index_collections_on_metadata", using: :gin
  end

  create_table "content_units", force: :cascade do |t|
    t.bigint "section_id"
    t.uuid "uuid", default: -> { "uuid_generate_v4()" }, null: false
    t.bigint "resource_id"
    t.jsonb "metadata"
    t.string "name"
    t.string "content"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["metadata"], name: "index_content_units_on_metadata", using: :gin
    t.index ["resource_id"], name: "index_content_units_on_resource_id"
    t.index ["section_id"], name: "index_content_units_on_section_id"
  end

  create_table "resources", force: :cascade do |t|
    t.uuid "uuid", default: -> { "uuid_generate_v4()" }, null: false
    t.bigint "collection_id"
    t.string "name"
    t.string "uri"
    t.jsonb "content"
    t.jsonb "metadata"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["collection_id"], name: "index_resources_on_collection_id"
    t.index ["metadata"], name: "index_resources_on_metadata", using: :gin
  end

  create_table "sections", force: :cascade do |t|
    t.bigint "resource_id"
    t.uuid "uuid", default: -> { "uuid_generate_v4()" }, null: false
    t.string "name"
    t.jsonb "metadata"
    t.string "ancestry"
    t.boolean "is_leaf", default: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["ancestry"], name: "index_sections_on_ancestry"
    t.index ["is_leaf"], name: "index_sections_on_is_leaf"
    t.index ["metadata"], name: "index_sections_on_metadata", using: :gin
    t.index ["resource_id"], name: "index_sections_on_resource_id"
  end

end
