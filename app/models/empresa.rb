class Empresa < ApplicationRecord
  has_secure_password

  # Validaciones
  validates :nombre, :industria, :correo, :nit, presence: true
  validates :password, presence: true, on: :create
  validates :correo, uniqueness: true, format: { with: URI::MailTo::EMAIL_REGEXP }
  validates :nit, uniqueness: true
end
