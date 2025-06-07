class Application < ApplicationRecord
  # Relaciones
  belongs_to :user, class_name: 'Voluntario', foreign_key: 'user_id'
  belongs_to :vacancy, class_name: 'Vacante', foreign_key: 'vacancy_id'
  
  # Validaciones
  validates :user_id, presence: true
  validates :vacancy_id, presence: true
  validates :application_date, presence: true
  validates :user_id, uniqueness: { scope: :vacancy_id, message: "has already applied to this vacancy" }
  
  # Constantes para los estados posibles
  STATUSES = %w[pending review interview selected rejected withdrawn].freeze
  
  # Validación para asegurar que el estado sea uno de los permitidos
  validates :status, inclusion: { in: STATUSES }
  
  # Callbacks
  before_validation :set_application_date, on: :create
  before_validation :set_default_status, on: :create
  
  private
  
  def set_application_date
    self.application_date ||= Time.current
  end
  
  def set_default_status
    self.status ||= 'pending'
  end
end
