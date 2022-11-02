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

ActiveRecord::Schema[7.0].define(version: 2020_10_06_233745) do
  create_table "logs", force: :cascade do |t|
    t.string "user", null: false
    t.string "endpoint", null: false
    t.datetime "datetime", precision: nil, null: false
  end

  create_table "match_players", force: :cascade do |t|
    t.string "player_name"
    t.string "player_email"
    t.boolean "approved"
    t.integer "score"
    t.integer "match_id"
    t.index ["match_id"], name: "index_match_players_on_match_id"
  end

  create_table "matches", force: :cascade do |t|
    t.string "description", null: false
    t.string "creator_name", null: false
    t.string "creator_email", null: false
    t.integer "status", null: false
    t.integer "topic", null: false
    t.index ["status"], name: "index_matches_on_status"
    t.index ["topic"], name: "index_matches_on_topic"
  end

  create_table "matches_questions", id: false, force: :cascade do |t|
    t.integer "match_id", null: false
    t.integer "question_id", null: false
  end

  create_table "question_options", force: :cascade do |t|
    t.string "description"
    t.integer "question_id"
    t.index ["question_id"], name: "index_question_options_on_question_id"
  end

  create_table "questions", force: :cascade do |t|
    t.string "description"
    t.integer "right_option"
  end

  add_foreign_key "match_players", "matches"
  add_foreign_key "question_options", "questions"
end
