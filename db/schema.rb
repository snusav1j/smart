# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[8.0].define(version: 2025_11_02_160320) do
  create_table "p2p_files", force: :cascade do |t|
    t.integer "p2p_id", null: false
    t.string "file_name", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["p2p_id"], name: "index_p2p_files_on_p2p_id"
  end

  create_table "p2ps", force: :cascade do |t|
    t.integer "order_id"
    t.integer "sell_order_id"
    t.integer "user_id"
    t.float "rub_per_usd"
    t.float "order_sum"
    t.integer "p2p_type"
    t.integer "bank_id"
    t.float "bank_comission"
    t.boolean "tax_paid", default: false
    t.float "tax_rate", default: 13.0
    t.datetime "order_date"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.float "usdt_count"
    t.float "extra_sell_summ"
    t.float "comission_rub"
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  add_foreign_key "p2p_files", "p2ps"
end
