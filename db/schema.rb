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

ActiveRecord::Schema.define(:version => 20101128080757) do

  create_table "contests", :force => true do |t|
    t.string   "name"
    t.datetime "start_time"
    t.datetime "end_time"
    t.string   "visible_group"
    t.string   "moderate_group"
    t.string   "author_group"
    t.string   "path"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "contests_problems", :id => false, :force => true do |t|
    t.integer "contest_id", :null => false
    t.integer "problem_id", :null => false
  end

  add_index "contests_problems", ["contest_id", "problem_id"], :name => "index_contests_problems_on_contest_id_and_problem_id", :unique => true

  create_table "problems", :force => true do |t|
    t.string   "name"
    t.string   "path"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "submissions", :force => true do |t|
    t.integer  "problem_id"
    t.integer  "user_id"
    t.integer  "result"
    t.datetime "time"
    t.integer  "used_memory"
    t.integer  "used_time"
    t.string   "lang"
    t.string   "visible_group"
    t.string   "path"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "users", :force => true do |t|
    t.string   "name"
    t.string   "nick"
    t.string   "group"
    t.string   "email"
    t.datetime "last_login"
    t.string   "signature"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
