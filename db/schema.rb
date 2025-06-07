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

ActiveRecord::Schema[7.1].define(version: 2025_06_06_235958) do
  create_schema "_heroku"

  # These are extensions that must be enabled in order to support this database
  enable_extension "pg_stat_statements"
  enable_extension "plpgsql"

  create_table "applications", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.bigint "vacancy_id", null: false
    t.datetime "application_date", default: -> { "CURRENT_TIMESTAMP" }, null: false
    t.string "status", default: "pending", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["status"], name: "index_applications_on_status"
    t.index ["user_id", "vacancy_id"], name: "index_applications_on_user_id_and_vacancy_id", unique: true
    t.index ["user_id"], name: "index_applications_on_user_id"
    t.index ["vacancy_id"], name: "index_applications_on_vacancy_id"
  end

  create_table "empresas", force: :cascade do |t|
    t.string "nombre"
    t.string "industria"
    t.string "tamano"
    t.text "descripcion"
    t.string "nombre_contacto"
    t.string "apellido_contacto"
    t.string "correo"
    t.string "telefono"
    t.string "password_digest"
    t.string "nit"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "proyectos", force: :cascade do |t|
    t.string "title"
    t.text "description"
    t.string "location"
    t.string "tags", default: [], array: true
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "company_id"
    t.index ["company_id"], name: "index_proyectos_on_company_id"
    t.index ["tags"], name: "index_proyectos_on_tags", using: :gin
  end

  create_table "vacantes", force: :cascade do |t|
    t.integer "company_id"
    t.integer "project_id"
    t.string "title"
    t.text "description"
    t.integer "vacancies_count"
    t.string "tags", default: [], array: true
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "image"
    t.date "expiration_date"
    t.index ["company_id"], name: "index_vacantes_on_company_id"
    t.index ["project_id"], name: "index_vacantes_on_project_id"
    t.index ["tags"], name: "index_vacantes_on_tags", using: :gin
  end

  create_table "voluntarios", force: :cascade do |t|
    t.string "first_name"
    t.string "last_name"
    t.string "email"
    t.string "password_digest"
    t.string "phone"
    t.date "date_of_birth"
    t.string "document_type"
    t.string "document_number"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_foreign_key "applications", "vacantes", column: "vacancy_id"
  add_foreign_key "applications", "voluntarios", column: "user_id"
  add_foreign_key "vacantes", "proyectos", column: "project_id"
end
