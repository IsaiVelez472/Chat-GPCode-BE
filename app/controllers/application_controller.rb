class ApplicationController < ActionController::API
  # Crear instancia del contexto de traducción de errores
  def error_translator
    @error_translator ||= ErrorHandling::ErrorTranslatorContext.new
  end
  
  # Manejar errores de ActiveRecord con traducción
  def handle_record_not_found(exception, message = 'Recurso no encontrado')
    render json: { error: message }, status: :not_found
  end
  
  # Manejar errores de validación con traducción
  def handle_validation_errors(record)
    errores = error_translator.translate(record.errors)
    render json: { errores: errores }, status: :unprocessable_entity
  end
  
  # Manejar errores genéricos
  def handle_error(message = 'Ha ocurrido un error', status = :unprocessable_entity)
    render json: { error: message }, status: status
  end
end
