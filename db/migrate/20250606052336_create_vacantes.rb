class CreateVacantes < ActiveRecord::Migration[7.1]
  def change
    create_table :vacantes do |t|
      t.integer :company_id
      t.integer :project_id
      t.string :title
      t.text :description
      t.integer :vacancies_count
      t.string :tags, array: true, default: []

      t.timestamps
    end
    
    # Añadir índices para mejorar el rendimiento de las consultas
    add_index :vacantes, :company_id
    add_index :vacantes, :project_id
    add_index :vacantes, :tags, using: 'gin'
    
    # Añadir restricción de clave foránea
    add_foreign_key :vacantes, :proyectos, column: :project_id
  end
end
