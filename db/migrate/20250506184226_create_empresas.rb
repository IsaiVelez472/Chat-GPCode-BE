class CreateEmpresas < ActiveRecord::Migration[7.1]
  def change
    create_table :empresas do |t|
      t.string :nombre
      t.string :industria
      t.string :tamano
      t.string :sitio_web
      t.text :descripcion
      t.string :nombre_contacto
      t.string :apellido_contacto
      t.string :correo
      t.string :telefono
      t.string :password_digest
      t.string :nit

      t.timestamps
    end
  end
end
