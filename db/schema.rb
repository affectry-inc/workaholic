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

ActiveRecord::Schema.define(version: 20160113081650) do

  create_table "approvers", force: :cascade do |t|
    t.integer  "user_id"
    t.integer  "approver_user_id"
    t.datetime "created_at",       null: false
    t.datetime "updated_at",       null: false
  end

  create_table "categories", force: :cascade do |t|
    t.integer  "ctgr_id"
    t.integer  "lang_id"
    t.integer  "val"
    t.string   "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "group_members", force: :cascade do |t|
    t.integer  "group_id"
    t.integer  "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "group_relations", force: :cascade do |t|
    t.integer  "applicant_group_id"
    t.integer  "approver_group_id"
    t.datetime "created_at",         null: false
    t.datetime "updated_at",         null: false
  end

  create_table "groups", force: :cascade do |t|
    t.string   "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer  "priv_level"
  end

  create_table "languages", force: :cascade do |t|
    t.integer  "lang_id"
    t.string   "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "paid_holiday_usages", force: :cascade do |t|
    t.integer  "paid_holiday_id"
    t.integer  "user_id"
    t.date     "usage_date"
    t.integer  "days"
    t.integer  "hours"
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
  end

  create_table "paid_holidays", force: :cascade do |t|
    t.integer  "user_id"
    t.integer  "days"
    t.integer  "hours"
    t.date     "beginning_date"
    t.date     "expiration_date"
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
  end

  create_table "report_requests", force: :cascade do |t|
    t.integer  "report_id"
    t.integer  "submitter_user_id"
    t.datetime "created_at",                        null: false
    t.datetime "updated_at",                        null: false
    t.boolean  "approved",          default: false
  end

  create_table "report_submissions", force: :cascade do |t|
    t.integer  "report_request_id"
    t.string   "file_name"
    t.datetime "submission_time"
    t.datetime "created_at",        null: false
    t.datetime "updated_at",        null: false
  end

  create_table "reports", force: :cascade do |t|
    t.integer  "receiver_user_id"
    t.string   "report_name"
    t.date     "beginning_date"
    t.date     "due_date"
    t.datetime "created_at",       null: false
    t.datetime "updated_at",       null: false
  end

  create_table "timecards", force: :cascade do |t|
    t.date     "biz_date"
    t.integer  "attn_ctgr"
    t.datetime "work_start_time"
    t.datetime "work_end_time"
    t.datetime "rest_start_time"
    t.datetime "rest_end_time"
    t.datetime "created_at",                     null: false
    t.datetime "updated_at",                     null: false
    t.integer  "user_id"
    t.integer  "wf_status",          default: 0
    t.integer  "paid_holiday_hours", default: 0
  end

  create_table "users", force: :cascade do |t|
    t.string   "name"
    t.string   "email"
    t.datetime "created_at",                          null: false
    t.datetime "updated_at",                          null: false
    t.string   "password_digest"
    t.string   "remember_digest"
    t.boolean  "admin",               default: false
    t.boolean  "use_def_times",       default: false
    t.time     "def_work_start_time"
    t.time     "def_work_end_time"
    t.time     "def_rest_start_time"
    t.time     "def_rest_end_time"
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true

end
