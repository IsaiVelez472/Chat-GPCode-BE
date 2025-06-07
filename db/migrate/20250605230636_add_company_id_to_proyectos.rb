class AddCompanyIdToProyectos < ActiveRecord::Migration[7.1]
  def change
    add_column :proyectos, :company_id, :integer
    add_index :proyectos, :company_id
  end
end
