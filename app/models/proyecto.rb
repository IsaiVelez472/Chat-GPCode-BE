class Proyecto < ApplicationRecord
  # Asegurar que los campos requeridos estén presentes
  validates :title, presence: true
  validates :description, presence: true
  validates :location, presence: true
  validates :company_id, presence: true
  
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
  
  # Relación con la empresa
  belongs_to :empresa, foreign_key: 'company_id', optional: true
  
  # Relación con las vacantes
  has_many :vacantes, foreign_key: 'project_id', dependent: :destroy
end
