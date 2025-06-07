class AddImageAndExpirationDateToVacantes < ActiveRecord::Migration[7.1]
  def change
    add_column :vacantes, :image, :string
    add_column :vacantes, :expiration_date, :date
  end
end
