# Chat-GPCode-BE

Chat-GPCode-BE es una API REST desarrollada con Ruby 3.4 y Rails 7.1+ que sirve como backend para la aplicación Chat-GPCode.

## Requisitos del sistema

### macOS

- Ruby 3.4.0 (recomendado usar rbenv para gestionar versiones de Ruby)
- Rails 7.1+
- PostgreSQL 14+
- Bundler 2.4+

### Windows

- Ruby 3.4.0 (usando RubyInstaller o WSL2)
- Rails 7.1+
- PostgreSQL 14+
- Bundler 2.4+

## Guía de instalación

### macOS

1. **Instalar Homebrew** (si no lo tienes instalado):

   ```bash
   /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
   ```

2. **Instalar rbenv y ruby-build**:

   ```bash
   brew install rbenv ruby-build
   echo 'eval "$(rbenv init -)"' >> ~/.zshrc
   source ~/.zshrc
   ```

3. **Instalar Ruby 3.4.0**:

   ```bash
   rbenv install 3.4.0
   rbenv global 3.4.0
   rbenv local 3.4.0
   ```

4. **Instalar PostgreSQL**:

   ```bash
   brew install postgresql@14
   brew services start postgresql@14
   ```

5. **Instalar Rails y dependencias**:
   ```bash
   gem install bundler
   gem install rails -v "~> 7.1.0"
   ```

### Windows

1. **Usando RubyInstaller (opción más sencilla)**:

   - Descargar e instalar RubyInstaller para Ruby 3.4.0 desde [RubyInstaller.org](https://rubyinstaller.org/)
   - Asegurarse de marcar la opción para instalar MSYS2 durante la instalación
   - Seguir las instrucciones del instalador

2. **Instalar PostgreSQL**:

   - Descargar e instalar PostgreSQL 14+ desde [postgresql.org](https://www.postgresql.org/download/windows/)

3. **Instalar Rails y dependencias**:

   ```bash
   gem install bundler
   gem install rails -v "~> 7.1.0"
   ```

4. **Alternativa: Usar WSL2 (Windows Subsystem for Linux)**:
   - Instalar WSL2 siguiendo las [instrucciones oficiales de Microsoft](https://docs.microsoft.com/en-us/windows/wsl/install)
   - Instalar una distribución de Linux (como Ubuntu)
   - Seguir las instrucciones de instalación para macOS dentro de WSL2

## Configuración del proyecto

1. **Clonar el repositorio**:

   ```bash
   git clone https://github.com/tu-usuario/Chat-GPCode-BE.git
   cd Chat-GPCode-BE
   ```

2. **Instalar dependencias**:

   ```bash
   bundle install
   ```

3. **Configurar la base de datos**:

   - Copiar el archivo de ejemplo de configuración:
     ```bash
     cp config/database.yml.example config/database.yml
     ```
   - Editar `config/database.yml` con tus credenciales de PostgreSQL

4. **Crear y migrar la base de datos**:
   ```bash
   rails db:create
   rails db:migrate
   ```

## Ejecutar el proyecto

1. **Iniciar el servidor de desarrollo**:

   ```bash
   rails server -p 3000
   ```

2. **Verificar que el servidor está funcionando**:
   - Visitar `http://localhost:3000/health` en tu navegador
   - O usar curl: `curl http://localhost:3000/health`

## Endpoints disponibles

- `GET /health` - Health check para verificar que la API está funcionando correctamente

## Pruebas

Para ejecutar las pruebas:

```bash
rails test
```

## Despliegue

### Heroku

```bash
heroku create
git push heroku main
heroku run rails db:migrate
```

### Railway

```bash
railway login
railway link
railway up
```

## Licencia

Este proyecto está bajo la Licencia MIT.
