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

ActiveRecord::Schema.define(version: 20150816023808) do

  create_table "alarms", force: true do |t|
    t.integer  "user_id"
    t.time     "time"
    t.string   "message"
    t.string   "days",          default: "ALL"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "title"
    t.boolean  "read_calendar"
  end

  create_table "meal_times", force: true do |t|
    t.integer  "user_id"
    t.string   "name"
    t.time     "time"
    t.string   "meal_type"
    t.integer  "recipe_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "messages", force: true do |t|
    t.integer  "personality_id"
    t.string   "text"
    t.boolean  "subject"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "personalities", force: true do |t|
    t.integer  "user_id"
    t.string   "name",       default: "Jarvis"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "recipes", force: true do |t|
    t.string   "name"
    t.string   "meal_type"
    t.string   "link"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "scheduled_events", force: true do |t|
    t.integer  "user_id"
    t.integer  "schedule_id"
    t.integer  "event_id"
    t.string   "event_type"
    t.time     "time"
    t.integer  "duration",    default: 15
    t.boolean  "completed",   default: false
    t.boolean  "ignored",     default: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "schedules", force: true do |t|
    t.integer  "user_id"
    t.date     "date"
    t.time     "wake_up_time", default: '2000-01-01 10:00:00'
    t.time     "sleep_time",   default: '2000-01-01 00:00:00'
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "taggings", force: true do |t|
    t.integer  "tag_id"
    t.integer  "taggable_id"
    t.string   "taggable_type"
    t.integer  "tagger_id"
    t.string   "tagger_type"
    t.string   "context",       limit: 128
    t.datetime "created_at"
  end

  add_index "taggings", ["tag_id", "taggable_id", "taggable_type", "context", "tagger_id", "tagger_type"], name: "taggings_idx", unique: true
  add_index "taggings", ["taggable_id", "taggable_type", "context"], name: "index_taggings_on_taggable_id_and_taggable_type_and_context"

  create_table "tags", force: true do |t|
    t.string  "name"
    t.integer "taggings_count", default: 0
  end

  add_index "tags", ["name"], name: "index_tags_on_name", unique: true

  create_table "tasks", force: true do |t|
    t.integer  "user_id"
    t.string   "description"
    t.integer  "minutes",        default: 15
    t.integer  "completed",      default: 0
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "priority"
    t.string   "preferred_time", default: "none"
  end

  create_table "tokens", force: true do |t|
    t.integer  "user_id"
    t.string   "access_token"
    t.string   "refresh_token"
    t.datetime "expires_at"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "users", force: true do |t|
    t.string   "name"
    t.string   "gender"
    t.string   "email",                  default: "", null: false
    t.string   "encrypted_password",     default: "", null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true

end
