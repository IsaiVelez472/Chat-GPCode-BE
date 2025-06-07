class Vacante < ApplicationRecord
  # Validaciones para los campos requeridos
  validates :company_id, presence: true
  validates :project_id, presence: true
  validates :title, presence: true
  validates :description, presence: true
  validates :vacancies_count, presence: true, numericality: { greater_than: 0 }
  validates :expiration_date, presence: true
  
  # Relaciones con otros modelos
  belongs_to :proyecto, foreign_key: 'project_id'
  belongs_to :empresa, foreign_key: 'company_id', optional: true
  has_many :applications, foreign_key: 'vacancy_id', dependent: :destroy
  has_many :applicants, through: :applications, source: :user
  
  # Configuración para manejar el campo tags como un array
  serialize :tags, Array if !defined?(ActiveRecord::ConnectionAdapters::PostgreSQLAdapter) || !connection.is_a?(ActiveRecord::ConnectionAdapters::PostgreSQLAdapter)
  
  # En PostgreSQL, los arrays son manejados nativamente
  def tags=(value)
    if value.is_a?(String)
      # Si se proporciona como string JSON, convertir a array
      super(JSON.parse(value)) rescue super
    else
      super
    end
  end
  
  # Método para obtener las aplicaciones por estado
  def applications_by_status(status)
    applications.where(status: status)
  end
end
