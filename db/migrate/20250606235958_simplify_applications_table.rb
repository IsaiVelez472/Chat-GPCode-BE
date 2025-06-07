class SimplifyApplicationsTable < ActiveRecord::Migration[7.1]
  def change
    # Eliminar campos no necesarios
    remove_column :applications, :cover_letter, :text
    remove_column :applications, :notes, :text
    remove_column :applications, :additional_data, :jsonb
    
    # Asegurar que el status sea siempre 'pending' por defecto
    change_column_default :applications, :status, 'pending'
  end
end
