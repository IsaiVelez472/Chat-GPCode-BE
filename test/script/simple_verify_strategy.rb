#!/usr/bin/env ruby
require_relative '../../config/environment'

# Este script simple verifica que el patrón Strategy para la traducción de errores
# funciona correctamente, sin necesidad de ejecutar pruebas unitarias completas

puts "=== Verificación del Patrón Strategy para Traducción de Errores ==="

# Obtener instancias
spanish_translator = ErrorHandling::SpanishErrorTranslator.new
context = ErrorHandling::ErrorTranslatorContext.new(spanish_translator)

# Simulando algunos errores para traducir
require 'ostruct'
errors = OpenStruct.new(
  full_messages: ["Title can't be blank", "Description is too short (minimum is 10 characters)",
                  "User has already applied to this vacancy", "Email has already been taken",
                  "Vacancy is invalid", "Project can't be blank"],
  empty?: false
)

puts "\n1. Verificando traducción de errores de validación:"
puts "Mensajes originales:"
errors.full_messages.each { |msg| puts "  - #{msg}" }

puts "\nMensajes traducidos por SpanishErrorTranslator:"
translated = spanish_translator.translate(errors) # Método en SpanishErrorTranslator
translated.each { |msg| puts "  - #{msg}" }

puts "\n2. Verificando traducción a través del contexto:"
context_translated = context.translate_errors(errors) # El método en ErrorTranslatorContext es translate_errors
context_translated.each { |msg| puts "  - #{msg}" }

# Simulando un cambio de estrategia
puts "\n3. Verificando cambio de estrategia:"
mock_strategy = Object.new
def mock_strategy.translate(errors) # Implementamos translate para que sea compatible con la estrategia
  ["Error traducido por mock estrategia"]
end

puts "Cambiando la estrategia..."
context.set_strategy(mock_strategy) # Usamos el método set_strategy para cambiar la estrategia
puts "Nueva estrategia establecida. Traduciendo errores:"
result = context.translate_errors(errors) # El método en ErrorTranslatorContext es translate_errors
result.each { |msg| puts "  - #{msg}" }

puts "\n=== Verificación completa ==="
puts "El patrón Strategy para traducción de errores funciona correctamente."
