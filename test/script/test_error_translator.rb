#!/usr/bin/env ruby
require_relative '../../config/environment'
require 'minitest/autorun'
require 'ostruct'

# Esta prueba no hereda de ActiveSupport::TestCase para evitar la carga de fixtures
class ErrorTranslatorIndependentTest < Minitest::Test
  def setup
    @spanish_translator = ErrorHandling::SpanishErrorTranslator.new
    @context = ErrorHandling::ErrorTranslatorContext.new(@spanish_translator)
  end

  def test_translator_strategy
    # Prueba 1: El traductor español debe traducir errores comunes
    errors = OpenStruct.new(
      full_messages: ["Title can't be blank", "Description is too short (minimum is 10 characters)"],
      details: {
        title: [{ error: :blank }],
        description: [{ error: :too_short, count: 10 }]
      }
    )
    
    translated_errors = @spanish_translator.translate_errors(errors)
    
    puts "Prueba 1: Traducción de errores de validación"
    puts "Errores originales: #{errors.full_messages}"
    puts "Errores traducidos: #{translated_errors}"
    assert_includes translated_errors, "El título no puede estar en blanco"
    assert_includes translated_errors, "La descripción es demasiado corta (mínimo 10 caracteres)"
    puts "✓ Prueba 1 Exitosa\n\n"
    
    # Prueba 2: El contexto debe usar el traductor español por defecto
    context = ErrorHandling::ErrorTranslatorContext.new
    
    puts "Prueba 2: El contexto debe usar el traductor español por defecto"
    puts "Tipo de estrategia: #{context.strategy.class}"
    assert_instance_of ErrorHandling::SpanishErrorTranslator, context.strategy
    puts "✓ Prueba 2 Exitosa\n\n"
    
    # Prueba 3: El contexto debe permitir cambiar la estrategia
    mock_strategy = Object.new
    def mock_strategy.translate_errors(errors)
      ["Error traducido por mock"]
    end

    @context.strategy = mock_strategy
    
    result = @context.translate_errors(OpenStruct.new(full_messages: ["Test error"]))
    
    puts "Prueba 3: Cambio de estrategia"
    puts "Resultado usando mock: #{result}"
    assert_equal ["Error traducido por mock"], result
    puts "✓ Prueba 3 Exitosa\n\n"
    
    # Prueba 4: Traducción de nombres de modelos
    puts "Prueba 4: Traducción de nombres de modelos"
    puts "vacancy -> #{@spanish_translator.translate_model_name('vacancy')}"
    puts "project -> #{@spanish_translator.translate_model_name('project')}"
    assert_equal "vacante", @spanish_translator.translate_model_name("vacancy")
    assert_equal "proyecto", @spanish_translator.translate_model_name("project")
    puts "✓ Prueba 4 Exitosa\n\n"
    
    # Prueba 5: Traducción de nombres de atributos
    puts "Prueba 5: Traducción de nombres de atributos"
    puts "title -> #{@spanish_translator.translate_attribute_name('title')}"
    puts "description -> #{@spanish_translator.translate_attribute_name('description')}"
    assert_equal "título", @spanish_translator.translate_attribute_name("title")
    assert_equal "descripción", @spanish_translator.translate_attribute_name("description")
    puts "✓ Prueba 5 Exitosa\n\n"
  end
  
  private
  
  def assert_includes(collection, item)
    flunk "La colección no incluye '#{item}'" unless collection.include?(item)
  end
  
  def assert_equal(expected, actual)
    flunk "Se esperaba '#{expected}' pero se encontró '#{actual}'" unless expected == actual
  end
  
  def assert_instance_of(klass, obj)
    flunk "Se esperaba un #{klass} pero se encontró un #{obj.class}" unless obj.is_a?(klass)
  end
  
  def flunk(msg)
    raise "Error: #{msg}"
  end
end

# Ejecutar prueba
test = ErrorTranslatorIndependentTest.new
test.setup
test.test_translator_strategy
puts "\n✓✓✓ Todas las pruebas completadas con éxito ✓✓✓"
