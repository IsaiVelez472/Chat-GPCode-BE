# Configuración de Heroku Postgres

Este documento explica cómo configurar la aplicación para conectarse a Heroku Postgres.

## Configuración local para desarrollo

1. **Instala las dependencias**:
   ```bash
   bundle install
   ```

2. **Configura las variables de entorno**:
   - Crea un archivo `.env` en la raíz del proyecto (este archivo está en `.gitignore` para proteger tus credenciales)
   - Copia el contenido de `config/heroku_database.yml.example` y reemplaza con tus credenciales reales de Heroku Postgres
   - Ejemplo de archivo `.env`:
     ```
     DATABASE_URL=postgres://username:password@host:port/database_name
     ```

3. **Crea y migra la base de datos**:
   ```bash
   rails db:create
   rails db:migrate
   ```

## Configuración en Heroku

1. **Crea una aplicación en Heroku**:
   ```bash
   heroku create
   ```

2. **Añade el add-on de Heroku Postgres**:
   ```bash
   heroku addons:create heroku-postgresql:mini
   ```

3. **Verifica la URL de la base de datos**:
   ```bash
   heroku config:get DATABASE_URL
   ```

4. **Despliega la aplicación**:
   ```bash
   git push heroku main
   ```

5. **Ejecuta las migraciones en Heroku**:
   ```bash
   heroku run rails db:migrate
   ```

## Endpoints de la API

### Obtener todos los voluntarios
```
GET /voluntarios
```

### Obtener voluntario por documento
```
GET /voluntarios/documento/:document_type/:document_number
```
Ejemplo: `/voluntarios/documento/DNI/12345678`

### Crear un nuevo voluntario
```
POST /voluntarios
```
Cuerpo de la solicitud (JSON):
```json
{
  "voluntario": {
    "first_name": "Nombre",
    "last_name": "Apellido",
    "email": "correo@ejemplo.com",
    "password": "contraseña",
    "password_confirmation": "contraseña",
    "phone": "123456789",
    "date_of_birth": "1990-01-01",
    "document_type": "DNI",
    "document_number": "12345678"
  }
}
```

## Notas importantes

- La variable `DATABASE_URL` es utilizada automáticamente por Rails en producción.
- En desarrollo, la gema `dotenv-rails` carga las variables desde el archivo `.env`.
- Nunca subas el archivo `.env` a control de versiones.
- Los campos del modelo Voluntario corresponden al objeto JavaScript que proporcionaste, pero con nombres en formato snake_case según las convenciones de Ruby.
