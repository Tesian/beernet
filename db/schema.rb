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
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20121227124528) do

  create_table "accesses", :force => true do |t|
    t.string   "login"
    t.string   "password"
    t.string   "address"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
    t.integer  "project_id"
    t.string   "genre"
  end

  add_index "accesses", ["project_id"], :name => "index_accesses_on_project_id"

  create_table "boxes", :force => true do |t|
    t.integer "project_id"
    t.string  "app_name"
    t.string  "app_secret"
    t.string  "auth_token"
  end

  add_index "boxes", ["project_id"], :name => "index_boxes_on_project_id"

  create_table "clients", :force => true do |t|
    t.string   "name"
    t.string   "street"
    t.string   "zip"
    t.string   "town"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "contacts", :force => true do |t|
    t.string   "firstname"
    t.string   "lastname"
    t.string   "phone"
    t.string   "email"
    t.text     "other_data"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
    t.integer  "client_id"
  end

  add_index "contacts", ["client_id"], :name => "index_contacts_on_client_id"

  create_table "projects", :force => true do |t|
    t.string "name"
    t.text   "description"
  end

  create_table "projects_users", :force => true do |t|
    t.integer "user_id"
    t.integer "project_id"
  end

  add_index "projects_users", ["project_id"], :name => "index_projects_users_on_project_id"
  add_index "projects_users", ["user_id"], :name => "index_projects_users_on_user_id"

  create_table "todo_lists", :force => true do |t|
    t.string  "name"
    t.integer "project_id"
  end

  add_index "todo_lists", ["project_id"], :name => "index_todo_lists_on_project_id"

  create_table "todos", :force => true do |t|
    t.text    "body"
    t.integer "todo_list_id"
  end

  add_index "todos", ["todo_list_id"], :name => "index_todos_on_todo_list_id"

  create_table "users", :force => true do |t|
    t.string   "email",                  :default => "", :null => false
    t.string   "encrypted_password",     :default => "", :null => false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          :default => 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at",                             :null => false
    t.datetime "updated_at",                             :null => false
    t.string   "github",                 :default => ""
    t.string   "dropbox",                :default => ""
    t.string   "google",                 :default => ""
    t.string   "uid",                    :default => ""
  end

  add_index "users", ["email"], :name => "index_users_on_email", :unique => true
  add_index "users", ["reset_password_token"], :name => "index_users_on_reset_password_token", :unique => true

end
