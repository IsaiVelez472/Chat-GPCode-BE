class CreateVoluntarios < ActiveRecord::Migration[7.1]
  def change
    create_table :voluntarios do |t|
      t.string :first_name
      t.string :last_name
      t.string :email
      t.string :password_digest
      t.string :phone
      t.date :date_of_birth
      t.string :document_type
      t.string :document_number

      t.timestamps
    end
  end
end
