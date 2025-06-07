class CreateApplications < ActiveRecord::Migration[7.1]
  def change
    create_table :applications do |t|
      t.references :user, null: false, foreign_key: { to_table: :voluntarios }
      t.references :vacancy, null: false, foreign_key: { to_table: :vacantes }
      t.datetime :application_date, null: false, default: -> { 'CURRENT_TIMESTAMP' }
      t.string :status, null: false, default: 'pending'
      t.text :cover_letter
      t.text :notes
      t.jsonb :additional_data
      
      t.timestamps
    end
    
    # Índice para búsquedas frecuentes por estado
    add_index :applications, :status
    
    # Índice compuesto para evitar aplicaciones duplicadas
    add_index :applications, [:user_id, :vacancy_id], unique: true
  end
end
