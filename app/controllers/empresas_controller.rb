class EmpresasController < ApplicationController
  # GET /empresas
  def index
    @empresas = Empresa.all
    render json: @empresas, status: :ok
  end

  # GET /empresas/:id
  def show
    @empresa = Empresa.find(params[:id])
    render json: @empresa, status: :ok
  rescue ActiveRecord::RecordNotFound
    handle_record_not_found(nil, 'Empresa no encontrada')
  end

  # GET /empresas/nit/:nit
  def show_by_nit
    @empresa = Empresa.find_by(nit: params[:nit])
    
    if @empresa
      render json: @empresa, status: :ok
    else
      handle_record_not_found(nil, 'Empresa no encontrada')
    end
  end

  # POST /empresas
  def create
    @empresa = Empresa.new(empresa_params)

    if @empresa.save
      render json: @empresa, status: :created
    else
      handle_validation_errors(@empresa)
    end
  end

  # PUT/PATCH /empresas/:id
  def update
    @empresa = Empresa.find(params[:id])
    
    if @empresa.update(empresa_update_params)
      render json: @empresa, status: :ok
    else
      handle_validation_errors(@empresa)
    end
  rescue ActiveRecord::RecordNotFound
    handle_record_not_found(nil, 'Empresa no encontrada')
  end

  # POST /empresas/login
  def login
    # Determinar si el identificador es un email o un NIT
    identifier = login_params[:identifier]
    
    # Buscar la empresa según el tipo de identificador
    @empresa = if identifier.include?('@')
                 # Si contiene @, asumimos que es un email
                 Empresa.find_by(correo: identifier)
               else
                 # De lo contrario, asumimos que es un NIT
                 Empresa.find_by(nit: identifier)
               end
    
    # Verificar si la empresa existe y la contraseña es correcta
    if @empresa&.authenticate(login_params[:password])
      render json: @empresa, status: :ok
    else
      handle_error('Credenciales inválidas', :unauthorized)
    end
  end

  private

  def empresa_params
    params.require(:empresa).permit(
      :nombre,
      :industria,
      :tamano,
      :descripcion,
      :nombre_contacto,
      :apellido_contacto,
      :correo,
      :telefono,
      :password,
      :password_confirmation,
      :nit
    )
  end

  def empresa_update_params
    # Para actualizaciones solo permitimos los campos que se envían
    # y no requerimos que se envíen todos
    params.require(:empresa).permit(
      :nombre,
      :industria,
      :tamano,
      :descripcion,
      :nombre_contacto,
      :apellido_contacto,
      :correo,
      :telefono,
      :nit
    )
  end

  def login_params
    params.require(:empresa).permit(:identifier, :password)
  end
end
