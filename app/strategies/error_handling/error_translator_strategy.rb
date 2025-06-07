module ErrorHandling
  # Clase base para todas las estrategias de traducción de errores
  class ErrorTranslatorStrategy
    def translate(errors)
      # A ser implementado por subclases
      raise NotImplementedError, 'Subclases deben implementar el método translate'
    end
  end
end
