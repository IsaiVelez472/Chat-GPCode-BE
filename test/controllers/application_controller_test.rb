require "test_helper"

class ApplicationControllerTest < ActionDispatch::IntegrationTest
  # Usaremos una clase de prueba que hereda de ApplicationController
  # para probar sus métodos
  class TestController < ApplicationController
    def test_record_not_found
      handle_record_not_found(nil, "Mensaje de prueba")
    end

    def test_validation_errors
      # Creamos un modelo con errores para probar
      @model = Proyecto.new
      @model.validate # Esto añadirá errores ya que faltan campos requeridos
      handle_validation_errors(@model)
    end

    def test_generic_error
      handle_error("Error genérico de prueba", :unprocessable_entity)
    end

    # Definimos las rutas de prueba
    def self.controller_path
      "test"
    end
  end

  # Definimos las rutas temporales para nuestro controlador de prueba
  setup do
    Rails.application.routes.draw do
      get 'test/record_not_found' => 'application_controller_test/test#test_record_not_found'
      get 'test/validation_errors' => 'application_controller_test/test#test_validation_errors'
      get 'test/generic_error' => 'application_controller_test/test#test_generic_error'
    end
  end

  # Restauramos las rutas después de las pruebas
  teardown do
    Rails.application.reload_routes!
  end

  test "should handle record not found errors" do
    get "/test/record_not_found"
    assert_response :not_found
    
    json_response = JSON.parse(response.body)
    assert_equal "Mensaje de prueba", json_response["error"]
  end

  test "should handle validation errors" do
    get "/test/validation_errors"
    assert_response :unprocessable_entity
    
    json_response = JSON.parse(response.body)
    assert json_response["errores"].is_a?(Array)
    assert json_response["errores"].any? # Debería contener errores traducidos
  end

  test "should handle generic errors" do
    get "/test/generic_error"
    assert_response :unprocessable_entity
    
    json_response = JSON.parse(response.body)
    assert_equal "Error genérico de prueba", json_response["error"]
  end

  test "should have error_translator method" do
    controller = ApplicationController.new
    assert_respond_to controller, :error_translator
    assert_instance_of ErrorHandling::ErrorTranslatorContext, controller.error_translator
  end
end
