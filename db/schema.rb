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

ActiveRecord::Schema.define(version: 20140418234845) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "authentications", force: true do |t|
    t.integer  "user_id"
    t.string   "provider"
    t.string   "uid"
    t.string   "token"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "transactions", force: true do |t|
    t.integer "id_b"
    t.integer "id_l"
    t.date    "transaction_date"
    t.string  "description"
    t.boolean "reject",                                                default: false
    t.boolean "paidback",                                              default: false
    t.date    "date_paidback"
    t.integer "paidback_time"
    t.string  "reject_reason",    limit: 150
    t.decimal "amount",                       precision: 19, scale: 2
    t.string  "b_email",          limit: 100
    t.string  "l_email",          limit: 100
  end

  create_table "users", force: true do |t|
    t.string   "email_address",          limit: 100
    t.string   "fbnick",                 limit: 20
    t.string   "fb_uniqueid",            limit: 40
    t.string   "first_name",             limit: 20
    t.string   "last_name",              limit: 20
    t.string   "token",                  limit: 50
    t.boolean  "expired",                            default: false
    t.string   "profile_picture",        limit: 100
    t.integer  "expirey_date"
    t.date     "date_joined"
    t.float    "rating",                             default: 0.0
    t.string   "cover_photo",            limit: 100
    t.string   "encrypted_password",                 default: "",    null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",                      default: 0,     null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
  end

  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree

end
