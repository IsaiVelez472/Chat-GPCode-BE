require "test_helper"

class VoluntariosControllerTest < ActionDispatch::IntegrationTest
  setup do
    @voluntario_attributes = {
      first_name: "Juan",
      last_name: "Pérez",
      email: "juan.perez@example.com",
      password: "password123",
      password_confirmation: "password123",
      phone: "1234567890",
      date_of_birth: "1990-01-01",
      document_type: "CC",
      document_number: "12345678"
    }

    # Si se necesitan fixtures, asegúrate de que estén definidos en test/fixtures/voluntarios.yml
    # @voluntario = voluntarios(:one)
  end
  
  test "should get index" do
    get voluntarios_url, as: :json
    assert_response :success
    json_response = JSON.parse(response.body)
    assert_kind_of Array, json_response
  end

  test "should create voluntario" do
    assert_difference("Voluntario.count") do
      post voluntarios_url, params: { voluntario: @voluntario_attributes }, as: :json
    end
    assert_response :created
  end

  test "should use strategy pattern for validation errors" do
    # Intentar crear un voluntario con datos inválidos
    post voluntarios_url, params: { voluntario: { first_name: "" } }, as: :json
    
    assert_response :unprocessable_entity
    json_response = JSON.parse(response.body)
    
    # Verificar que se está usando la traducción de errores al español
    assert json_response.has_key?("errores")
    assert json_response["errores"].any?
    
    # Verificar que los mensajes están en español
    assert json_response["errores"].any? { |msg| msg.include?("nombre") }
  end

  test "should use strategy pattern for record not found" do
    # Intentar actualizar un voluntario que no existe
    patch voluntario_url(999), params: { voluntario: { first_name: "Updated" } }, as: :json
    
    assert_response :not_found
    json_response = JSON.parse(response.body)
    
    # Verificar que se está usando la traducción de errores
    assert_equal "Voluntario no encontrado", json_response["error"]
  end

  test "should use strategy pattern for login errors" do
    # Intentar iniciar sesión con credenciales inválidas
    post login_voluntarios_url, params: { voluntario: { identifier: "invalid@example.com", password: "wrongpassword" } }, as: :json
    
    assert_response :unauthorized
    json_response = JSON.parse(response.body)
    
    # Verificar que se está usando la traducción de errores
    assert_equal "Credenciales inválidas", json_response["error"]
  end
end
