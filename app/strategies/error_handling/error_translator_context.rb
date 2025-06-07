module ErrorHandling
  # Clase contexto que utiliza la estrategia de traducción
  class ErrorTranslatorContext
    def initialize(strategy = nil)
      @strategy = strategy || ErrorHandling::SpanishErrorTranslator.new
    end
    
    def set_strategy(strategy)
      @strategy = strategy
    end
    
    def translate_errors(errors)
      translate(errors)
    end
    
    def translate(errors)
      @strategy.translate(errors)
    end
  end
end
