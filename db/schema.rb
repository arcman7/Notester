# encoding: UTF-8
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

ActiveRecord::Schema.define(version: 20160226060501) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "categories", force: :cascade do |t|
    t.string   "name"
    t.integer  "parent_category_id"
    t.text     "description"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "categories", ["parent_category_id"], name: "index_categories_on_parent_category_id", using: :btree

  create_table "category_tags", force: :cascade do |t|
    t.integer "category_id"
    t.integer "tag_id"
  end

  create_table "relations", force: :cascade do |t|
    t.integer "child_id"
    t.integer "parent_id"
  end

  create_table "resource_categories", id: false, force: :cascade do |t|
    t.integer "resource_id"
    t.integer "category_id"
  end

  create_table "resource_tags", id: false, force: :cascade do |t|
    t.integer "resource_id"
    t.integer "tag_id"
  end

  create_table "resources", force: :cascade do |t|
    t.string   "title"
    t.text     "description"
    t.binary   "file"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "tags", force: :cascade do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "trees", force: :cascade do |t|
    t.integer  "category_id"
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "trees", ["category_id"], name: "index_trees_on_category_id", using: :btree

  create_table "users", force: :cascade do |t|
    t.string   "username"
    t.string   "password"
    t.string   "email"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "votes", force: :cascade do |t|
    t.integer  "value"
    t.integer  "user_id"
    t.integer  "resource_id"
    t.string   "unique_identifier"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
