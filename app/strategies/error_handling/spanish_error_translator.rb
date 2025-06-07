module ErrorHandling
  # Implementación específica para traducir errores al español
  class SpanishErrorTranslator < ErrorTranslatorStrategy
    def translate(errors)
      return [] if errors.nil? || errors.empty?
      
      errors.full_messages.map do |msg|
        # Traducciones comunes de mensajes de error
        msg = msg.dup # Crear una copia para evitar modificar el original
        
        # Traducción de mensajes comunes
        msg.gsub!('has already applied to this vacancy', 'ya ha aplicado a esta vacante')
        msg.gsub!('can\'t be blank', 'no puede estar en blanco')
        msg.gsub!('is not included in the list', 'no está incluido en la lista')
        msg.gsub!('is invalid', 'no es válido')
        msg.gsub!('has already been taken', 'ya ha sido tomado')
        
        # Traducción de modelos y atributos
        msg.gsub!(/^User/, 'Usuario')
        msg.gsub!(/^Vacancy/, 'Vacante')
        msg.gsub!(/^Status/, 'Estado')
        msg.gsub!(/^Project/, 'Proyecto')
        msg.gsub!(/^Company/, 'Empresa')
        msg.gsub!(/^Application/, 'Postulación')
        msg.gsub!(/^Email/, 'Correo electrónico')
        msg.gsub!(/^Password/, 'Contraseña')
        msg.gsub!(/^Title/, 'Título')
        msg.gsub!(/^Description/, 'Descripción')
        msg.gsub!(/^Location/, 'Ubicación')
        
        msg
      end
    end
  end
end
