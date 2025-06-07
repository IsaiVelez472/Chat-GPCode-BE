require "test_helper"
require "ostruct"

class SpanishErrorTranslatorTest < ActiveSupport::TestCase
  # Desactivamos fixtures para evitar problemas con el esquema de la base de datos
  self.use_transactional_tests = false
  self.use_instantiated_fixtures = false
  
  setup do
    @translator = ErrorHandling::SpanishErrorTranslator.new
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
    
    translated_errors = @translator.translate_errors(errors)
    
    assert_includes translated_errors, "El título no puede estar en blanco"
    assert_includes translated_errors, "La descripción es demasiado corta (mínimo 10 caracteres)"
  end
  
  test "should translate model names" do
    assert_equal "vacante", @translator.translate_model_name("vacancy")
    assert_equal "proyecto", @translator.translate_model_name("project")
    assert_equal "aplicación", @translator.translate_model_name("application")
    assert_equal "voluntario", @translator.translate_model_name("voluntario")
    assert_equal "empresa", @translator.translate_model_name("empresa")
    # Para un modelo no definido, debe devolver el nombre original
    assert_equal "unknown_model", @translator.translate_model_name("unknown_model")
  end
  
  test "should translate attribute names" do
    assert_equal "título", @translator.translate_attribute_name("title")
    assert_equal "descripción", @translator.translate_attribute_name("description")
    assert_equal "nombre", @translator.translate_attribute_name("name")
    # Para un atributo no definido, debe devolver el nombre original
    assert_equal "unknown_attribute", @translator.translate_attribute_name("unknown_attribute")
  end

  test "should translate generic message" do
    assert_equal "El recurso no pudo ser encontrado", @translator.translate_message("Resource not found")
    assert_equal "Mensaje desconocido", @translator.translate_message("Unknown message")
  end
end
