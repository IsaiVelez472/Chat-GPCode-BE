require 'test_helper'

class VoluntarioDecoratorTest < ActiveSupport::TestCase
  setup do
    @voluntario = OpenStruct.new(
      id: 1,
      first_name: "Juan",
      last_name: "Pérez",
      email: "juan.perez@example.com",
      phone: "1234567890",
      date_of_birth: Date.new(1990, 1, 1),
      document_type: "CC",
      document_number: "12345678"
    )
    
    @decorator = Decorators::VoluntarioDecorator.decorate(@voluntario)
  end
  
  test "debe devolver el nombre completo" do
    assert_equal "Juan Pérez", @decorator.nombre_completo
  end
  
  test "debe devolver información de contacto" do
    info = @decorator.informacion_contacto
    assert_equal "juan.perez@example.com", info[:email]
    assert_equal "1234567890", info[:telefono]
    assert_equal "Juan Pérez", info[:nombre]
  end
  
  test "debe devolver identificación formateada" do
    assert_equal "CC: 12345678", @decorator.identificacion
  end
  
  test "debe calcular la edad correctamente" do
    # Asumimos que la edad se calcula correctamente para la fecha fija
    # En un caso real, podríamos mockear Date.today para tener un resultado consistente
    edad_esperada = Date.today.year - 1990
    if Date.today < Date.new(Date.today.year, 1, 1)
      edad_esperada -= 1
    end
    
    assert_equal edad_esperada, @decorator.edad
  end
  
  test "debe devolver JSON básico" do
    json = @decorator.como_json_basico
    
    assert_equal 1, json[:id]
    assert_equal "Juan Pérez", json[:nombre_completo]
    assert_equal "juan.perez@example.com", json[:email]
    assert_equal "CC: 12345678", json[:identificacion]
  end
end
