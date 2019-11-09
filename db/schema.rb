# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `rails
# db:schema:load`. When creating a new database, `rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2019_11_09_031705) do

  create_table "holdings", force: :cascade do |t|
    t.string "cusip", null: false
    t.string "description", null: false
    t.float "par_value", null: false
    t.float "coupon", null: false
    t.integer "maturity", null: false
    t.string "sector", null: false
    t.string "quality", null: false
    t.decimal "price", null: false
    t.float "accrued", null: false
    t.string "currency", null: false
    t.decimal "market_value", null: false
    t.float "weight", null: false
    t.float "yield", null: false
    t.float "dur", null: false
    t.float "cov", null: false
    t.float "oas", null: false
    t.float "sprd_dur", null: false
    t.float "pd", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

end
