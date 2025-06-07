require "test_helper"
require "ostruct"

class ErrorTranslatorContextTest < ActiveSupport::TestCase
  # Desactivamos fixtures para evitar problemas con el esquema de la base de datos
  self.use_transactional_tests = false
  self.use_instantiated_fixtures = false
  
  setup do
    @context = ErrorHandling::ErrorTranslatorContext.new
  end

  test "should use spanish translator by default" do
    assert_instance_of ErrorHandling::SpanishErrorTranslator, @context.strategy
  end

  test "should change strategy" do
    # Crear un mock de una estrategia alternativa
    mock_strategy = Object.new
    
    # Configurar el mock
    def mock_strategy.translate_errors(errors)
      ["Error traducido por mock"]
    end

    # Cambiar la estrategia
    @context.strategy = mock_strategy
    
    # Verificar que la estrategia ha cambiado
    assert_equal mock_strategy, @context.strategy
    
    # Verificar que utiliza la nueva estrategia
    errors = OpenStruct.new(full_messages: ["Test error"])
    result = @context.translate_errors(errors)
    
    assert_equal ["Error traducido por mock"], result
  end

  test "should delegate translation to strategy" do
    errors = OpenStruct.new(
      full_messages: ["Name can't be blank"],
      details: {
        name: [{ error: :blank }]
      }
    )
    
    # El contexto debe delegar la traducción a la estrategia
    translated_errors = @context.translate_errors(errors)
    
    assert_kind_of Array, translated_errors
    assert translated_errors.any? { |msg| msg.include?("nombre") && msg.include?("blanco") }
  end
end
