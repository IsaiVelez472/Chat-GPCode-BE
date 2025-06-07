class RemoveSitioWebFromEmpresas < ActiveRecord::Migration[7.1]
  def change
    remove_column :empresas, :sitio_web, :string
  end
end
