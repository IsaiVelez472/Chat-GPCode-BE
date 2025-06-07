class CreateProyectos < ActiveRecord::Migration[7.1]
  def change
    create_table :proyectos do |t|
      t.string :title
      t.text :description
      t.string :location
      t.string :tags, array: true, default: []

      t.timestamps
    end
    
    add_index :proyectos, :tags, using: 'gin'
  end
end
