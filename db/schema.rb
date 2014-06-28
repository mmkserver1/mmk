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

ActiveRecord::Schema.define(:version => 20111205090956) do

  create_table "account_types", :force => true do |t|
    t.string   "name"
    t.text     "desc"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "accounts", :force => true do |t|
    t.integer  "patient_id"
    t.string   "code"
    t.integer  "account_type_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "active_admin_comments", :force => true do |t|
    t.integer  "resource_id",   :null => false
    t.string   "resource_type", :null => false
    t.integer  "author_id"
    t.string   "author_type"
    t.text     "body"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "namespace"
  end

  add_index "active_admin_comments", ["author_type", "author_id"], :name => "index_active_admin_comments_on_author_type_and_author_id"
  add_index "active_admin_comments", ["namespace"], :name => "index_active_admin_comments_on_namespace"
  add_index "active_admin_comments", ["resource_type", "resource_id"], :name => "index_admin_notes_on_resource_type_and_resource_id"

  create_table "admin_users", :force => true do |t|
    t.string   "email",                               :default => "", :null => false
    t.string   "encrypted_password",   :limit => 128, :default => "", :null => false
    t.string   "reset_password_token"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",                       :default => 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "admin_users", ["email"], :name => "index_admin_users_on_email", :unique => true
  add_index "admin_users", ["reset_password_token"], :name => "index_admin_users_on_reset_password_token", :unique => true

  create_table "client_devices", :force => true do |t|
    t.string   "manufacturer"
    t.string   "model"
    t.string   "imei"
    t.string   "imsi"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "delayed_jobs", :force => true do |t|
    t.integer  "priority",   :default => 0
    t.integer  "attempts",   :default => 0
    t.text     "handler"
    t.text     "last_error"
    t.datetime "run_at"
    t.datetime "locked_at"
    t.datetime "failed_at"
    t.string   "locked_by"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "delayed_jobs", ["priority", "run_at"], :name => "delayed_jobs_priority"

  create_table "doctor_patients", :force => true do |t|
    t.integer  "patient_id"
    t.integer  "doctor_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.text     "doctor_notification"
  end

  create_table "locations", :force => true do |t|
    t.integer  "target_id"
    t.integer  "target_type"
    t.float    "latitude"
    t.float    "longitude"
    t.float    "altitude"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "measurement_thresholds", :force => true do |t|
    t.string   "type"
    t.text     "value"
    t.integer  "patient_id"
    t.integer  "doctor_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "measurements_bloodpressures", :force => true do |t|
    t.integer  "max",               :limit => 2
    t.integer  "min",               :limit => 2
    t.integer  "pulse",             :limit => 2
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "client_device_id",               :default => 0
    t.integer  "medical_device_id",              :default => 0
    t.datetime "measured_at"
  end

  create_table "measurements_cardiograms", :force => true do |t|
    t.string   "filename",          :limit => 15
    t.integer  "hpc_mode_length",   :limit => 2
    t.integer  "qrs_duration",      :limit => 2
    t.integer  "heart_rate",        :limit => 2
    t.integer  "rhythm_result",     :limit => 1
    t.integer  "storage_data_type", :limit => 1
    t.binary   "rest_unparsed"
    t.text     "cardiogram"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "client_device_id",                :default => 0
    t.integer  "medical_device_id",               :default => 0
    t.datetime "measured_at"
  end

  create_table "measurements_glucoses", :force => true do |t|
    t.integer  "user_id"
    t.float    "value"
    t.string   "state"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "client_device_id",  :default => 0
    t.integer  "medical_device_id", :default => 0
    t.datetime "measured_at"
  end

  create_table "measurements_oxygens", :force => true do |t|
    t.integer  "user_id"
    t.integer  "spo2"
    t.integer  "pulse"
    t.text     "waveform"
    t.datetime "measured_at"
    t.integer  "client_device_id",  :default => 0
    t.integer  "medical_device_id", :default => 0
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "measurements_temperatures", :force => true do |t|
    t.integer  "user_id"
    t.float    "value"
    t.string   "units",             :limit => 1
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "client_device_id",               :default => 0
    t.integer  "medical_device_id",              :default => 0
    t.datetime "measured_at"
  end

  create_table "measurements_weights", :force => true do |t|
    t.integer  "user_id"
    t.float    "value"
    t.string   "unit"
    t.datetime "measured_at"
    t.integer  "client_device_id",  :default => 0
    t.integer  "medical_device_id", :default => 0
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "medical_device_lists", :force => true do |t|
    t.string   "device_type"
    t.string   "address"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "medical_devices", :force => true do |t|
    t.string   "name"
    t.string   "address"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "notifications", :force => true do |t|
    t.text     "desc"
    t.string   "level"
    t.integer  "patient_id"
    t.integer  "doctor_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "status",     :default => 0
  end

  create_table "software_packages", :force => true do |t|
    t.string   "version"
    t.string   "build"
    t.string   "filename"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "platform"
    t.string   "filename2"
  end

  create_table "users", :force => true do |t|
    t.string   "email",                               :default => "", :null => false
    t.string   "encrypted_password",   :limit => 128, :default => "", :null => false
    t.string   "reset_password_token"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",                       :default => 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "first_name"
    t.string   "last_name"
    t.integer  "gender",               :limit => 255
    t.date     "birthday"
    t.string   "type"
    t.string   "middle_name"
    t.string   "phone"
  end

  add_index "users", ["email"], :name => "index_users_on_email", :unique => true
  add_index "users", ["reset_password_token"], :name => "index_users_on_reset_password_token", :unique => true

end
