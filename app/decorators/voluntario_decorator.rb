module Decorators
  class VoluntarioDecorator < BaseDecorator
    def nombre_completo
      "#{first_name} #{last_name}"
    end
    
    def informacion_contacto
      {
        email: email,
        telefono: phone,
        nombre: nombre_completo
      }
    end
    
    # Formatea la información de identificación
    def identificacion
      "#{document_type}: #{document_number}"
    end
    
    # Calcula la edad basada en la fecha de nacimiento
    def edad
      return nil unless date_of_birth
      
      hoy = Date.today
      edad = hoy.year - date_of_birth.year
      edad -= 1 if hoy < date_of_birth + edad.years # ajuste para cumpleaños no alcanzado en el año actual
      edad
    end
    
    def como_json_basico
      {
        id: id,
        nombre_completo: nombre_completo,
        email: email,
        identificacion: identificacion
      }
    end
  end
end
