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

ActiveRecord::Schema.define(version: 2019_02_24_052829) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  # userと1対1であれば、userと同じでもいいかも。実用上はまとめておいてもいいかも
  create_table "omni_auth_tokens", force: :cascade do |t|
    t.string "token"
    t.bigint "user_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_omni_auth_tokens_on_user_id"
  end

  # has_oneだと面倒くさいことも出てくるので、必要性があるを考える
  create_table "profiles", force: :cascade do |t|
    t.string "name"
    t.string "avatar"
    t.text "pr"
    # ユーザーとは1対1だから、ユニーク制約を付けておいてもいいかも
    t.bigint "user_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_profiles_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    # GitHubだけのサービスという前提であれば、provider, uidのユニーク制約は必ずしも必須ではないかも
    t.string "provider"
    t.string "uid"
    # tokenだけが別テーブルが切り出されているだけなら、usersテーブルでもいいかも。
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  create_table "works", force: :cascade do |t|
    t.string "name"
    t.string "image"
    t.text "description"
    t.integer "repository_id", null: false
    t.string "language"
    t.string "svn_url", null: false
    t.integer "stargazers", null: false
    t.integer "forks", null: false
    t.integer "watchers", null: false
    t.bigint "user_id", null: false
    t.boolean "published", default: true, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["repository_id"], name: "index_works_on_repository_id", unique: true
    t.index ["user_id"], name: "index_works_on_user_id"
  end

  add_foreign_key "omni_auth_tokens", "users"
  add_foreign_key "profiles", "users"
  add_foreign_key "works", "users"
end
