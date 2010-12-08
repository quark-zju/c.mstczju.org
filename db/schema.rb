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
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20101208092555) do

  create_table "contests", :force => true do |t|
    t.string   "name"
    t.datetime "start_time"
    t.datetime "freeze_time"
    t.datetime "end_time"
    t.string   "visible_group"
    t.string   "moderate_group"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "contests", ["moderate_group"], :name => "index_contests_on_moderate_group"
  add_index "contests", ["name"], :name => "index_contests_on_name"
  add_index "contests", ["start_time"], :name => "index_contests_on_start_time"
  add_index "contests", ["visible_group"], :name => "index_contests_on_visible_group"

  create_table "problem_links", :force => true do |t|
    t.integer  "contest_id"
    t.integer  "problem_id"
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "problems", :force => true do |t|
    t.string   "title",        :null => false
    t.string   "source"
    t.integer  "memory_limit", :null => false
    t.integer  "time_limit",   :null => false
    t.integer  "accept_count"
    t.integer  "submit_count"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "problems", ["source"], :name => "index_problems_on_source"
  add_index "problems", ["title"], :name => "index_problems_on_title"

  create_table "submissions", :force => true do |t|
    t.integer  "problem_id"
    t.integer  "user_id"
    t.integer  "result"
    t.integer  "used_memory"
    t.integer  "used_time"
    t.string   "lang"
    t.string   "visible_group"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "submissions", ["created_at"], :name => "index_submissions_on_created_at"
  add_index "submissions", ["lang"], :name => "index_submissions_on_lang"
  add_index "submissions", ["problem_id"], :name => "index_submissions_on_problem_id"
  add_index "submissions", ["result"], :name => "index_submissions_on_result"
  add_index "submissions", ["user_id"], :name => "index_submissions_on_user_id"
  add_index "submissions", ["visible_group"], :name => "index_submissions_on_visible_group"

  create_table "user_caches", :force => true do |t|
    t.integer  "problem_id"
    t.integer  "user_id"
    t.datetime "first_accepted_time"
    t.integer  "attempt"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "user_caches", ["attempt"], :name => "index_user_caches_on_attempt"
  add_index "user_caches", ["first_accepted_time"], :name => "index_user_caches_on_first_accepted_time"
  add_index "user_caches", ["problem_id"], :name => "index_user_caches_on_problem_id"
  add_index "user_caches", ["user_id", "problem_id"], :name => "index_user_caches_on_user_id_and_problem_id"
  add_index "user_caches", ["user_id"], :name => "index_user_caches_on_user_id"

  create_table "users", :force => true do |t|
    t.string   "name"
    t.string   "nick"
    t.string   "group"
    t.string   "email"
    t.string   "salt"
    t.string   "encrypted_password"
    t.string   "signature"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "users", ["email"], :name => "index_users_on_email"
  add_index "users", ["name"], :name => "index_users_on_name"
  add_index "users", ["nick"], :name => "index_users_on_nick"

end
