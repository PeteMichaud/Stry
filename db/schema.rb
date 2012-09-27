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

ActiveRecord::Schema.define(:version => 20120926042550) do

  create_table "attachments", :force => true do |t|
    t.string   "file_file_name"
    t.string   "file_content_type"
    t.integer  "file_file_size"
    t.datetime "file_updated_at"
    t.text     "caption"
    t.integer  "sequence",          :limit => 1, :default => 0
    t.integer  "block_id"
    t.datetime "created_at",                                    :null => false
    t.datetime "updated_at",                                    :null => false
  end

  create_table "blocks", :force => true do |t|
    t.enum     "klass",      :limit => [:notes, :playable, :scripted, :cut_scene], :default => :notes, :null => false
    t.text     "content"
    t.integer  "sequence",   :limit => 2,                                          :default => 0
    t.integer  "scene_id"
    t.datetime "created_at",                                                                           :null => false
    t.datetime "updated_at",                                                                           :null => false
  end

  create_table "scenes", :force => true do |t|
    t.string   "title"
    t.text     "notes"
    t.integer  "narrative_intensity", :limit => 1, :default => 0
    t.integer  "gameplay_intensity",  :limit => 1, :default => 0
    t.integer  "sequence",            :limit => 2, :default => 0
    t.integer  "story_id"
    t.datetime "created_at",                                      :null => false
    t.datetime "updated_at",                                      :null => false
  end

  create_table "stories", :force => true do |t|
    t.string   "title",       :null => false
    t.text     "description"
    t.integer  "author_id",   :null => false
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
  end

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
  end

  add_index "users", ["email"], :name => "index_users_on_email", :unique => true
  add_index "users", ["reset_password_token"], :name => "index_users_on_reset_password_token", :unique => true

end
