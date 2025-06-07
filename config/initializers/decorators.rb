require 'delegate'

# Cargar automáticamente todos los decoradores
Rails.application.config.to_prepare do
  Dir[Rails.root.join('app/decorators/**/*.rb')].each { |file| require_dependency file }
end
