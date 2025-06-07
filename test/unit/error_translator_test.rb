require 'test_helper'
require 'ostruct'

# Esta clase elimina la dependencia de fixtures y de la base de datos
class NoFixturesTestCase < ActiveSupport::TestCase
  self.use_transactional_tests = false
  
  # Desactivar completamente los fixtures
  def self.fixtures(*args)
    # No hacer nada
  end
end

class ErrorTranslatorTest < NoFixturesTestCase
  setup do
    @spanish_translator = ErrorHandling::SpanishErrorTranslator.new
    @context = ErrorHandling::ErrorTranslatorContext.new(@spanish_translator)
  end

  test "should translate common validation errors" do
    # Simulamos un objeto errors con un mensaje en inglés
    errors = OpenStruct.new(
      full_messages: ["Title can't be blank", "Description is too short (minimum is 10 characters)"],
      details: {
        title: [{ error: :blank }],
        description: [{ error: :too_short, count: 10 }]
      }
    )
    
    # Traducción directa con la estrategia
    translated_errors = @spanish_translator.translate_errors(errors)
    
    assert_includes translated_errors, "El título no puede estar en blanco"
    assert_includes translated_errors, "La descripción es demasiado corta (mínimo 10 caracteres)"
    
    # Traducción a través del contexto
    context_translated_errors = @context.translate_errors(errors)
    
    assert_includes context_translated_errors, "El título no puede estar en blanco"
    assert_includes context_translated_errors, "La descripción es demasiado corta (mínimo 10 caracteres)"
  end
  
  test "should translate model names" do
    assert_equal "vacante", @spanish_translator.translate_model_name("vacancy")
    assert_equal "proyecto", @spanish_translator.translate_model_name("project")
    assert_equal "aplicación", @spanish_translator.translate_model_name("application")
    assert_equal "voluntario", @spanish_translator.translate_model_name("voluntario")
    assert_equal "empresa", @spanish_translator.translate_model_name("empresa")
    # Para un modelo no definido, debe devolver el nombre original
    assert_equal "unknown_model", @spanish_translator.translate_model_name("unknown_model")
  end
  
  test "should translate attribute names" do
    assert_equal "título", @spanish_translator.translate_attribute_name("title")
    assert_equal "descripción", @spanish_translator.translate_attribute_name("description")
    assert_equal "nombre", @spanish_translator.translate_attribute_name("name")
    # Para un atributo no definido, debe devolver el nombre original
    assert_equal "unknown_attribute", @spanish_translator.translate_attribute_name("unknown_attribute")
  end

  test "should translate generic message" do
    assert_equal "El recurso no pudo ser encontrado", @spanish_translator.translate_message("Resource not found")
    assert_equal "Mensaje desconocido", @spanish_translator.translate_message("Unknown message")
  end
  
  test "context should use spanish translator by default" do
    context = ErrorHandling::ErrorTranslatorContext.new
    assert_instance_of ErrorHandling::SpanishErrorTranslator, context.strategy
  end

  test "context should change strategy" do
    # Crear un objeto que actúe como una estrategia alternativa
    mock_strategy = Object.new
    
    # Añadir el método translate_errors a nuestro objeto
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
end
