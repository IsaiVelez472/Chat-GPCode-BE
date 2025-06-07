class Voluntario < ApplicationRecord
  has_secure_password

  # Validaciones
  validates :first_name, :last_name, :email, :document_type, :document_number, presence: true
  validates :password, presence: true, on: :create
  validates :email, uniqueness: true, format: { with: URI::MailTo::EMAIL_REGEXP }
  validates :document_number, uniqueness: { scope: :document_type }
  
  # Relaciones
  has_many :applications, foreign_key: 'user_id', dependent: :destroy
  has_many :applied_vacancies, through: :applications, source: :vacancy
end
