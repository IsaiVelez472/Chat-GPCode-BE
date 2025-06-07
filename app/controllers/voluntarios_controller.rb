class VoluntariosController < ApplicationController
  # GET /voluntarios
  def index
    @voluntarios = Voluntario.all
    render json: @voluntarios, status: :ok
  end

  # GET /voluntarios/documento/:document_type/:document_number
  def show_by_document
    @voluntario = Voluntario.find_by(document_type: params[:document_type], document_number: params[:document_number])
    
    if @voluntario
      render json: @voluntario, status: :ok
    else
      handle_record_not_found(nil, 'Voluntario no encontrado')
    end
  end

  # POST /voluntarios
  def create
    @voluntario = Voluntario.new(voluntario_params)

    if @voluntario.save
      render json: @voluntario, status: :created
    else
      handle_validation_errors(@voluntario)
    end
  end

  # PUT/PATCH /voluntarios/:id
  def update
    @voluntario = Voluntario.find(params[:id])
    
    if @voluntario.update(voluntario_update_params)
      render json: @voluntario, status: :ok
    else
      handle_validation_errors(@voluntario)
    end
  rescue ActiveRecord::RecordNotFound
    handle_record_not_found(nil, 'Voluntario no encontrado')
  end

  # POST /voluntarios/login
  def login
    # Determinar si el identificador es un email o un número de documento
    identifier = login_params[:identifier]
    
    # Buscar al voluntario según el tipo de identificador
    @voluntario = if identifier.include?('@')
                    # Si contiene @, asumimos que es un email
                    Voluntario.find_by(email: identifier)
                  else
                    # De lo contrario, asumimos que es un número de documento
                    Voluntario.find_by(document_number: identifier)
                  end
    
    # Verificar si el voluntario existe y la contraseña es correcta
    if @voluntario&.authenticate(login_params[:password])
      render json: @voluntario, status: :ok
    else
      handle_error('Credenciales inválidas', :unauthorized)
    end
  end

  private

  def voluntario_params
    params.require(:voluntario).permit(
      :first_name, 
      :last_name, 
      :email, 
      :password, 
      :password_confirmation, 
      :phone, 
      :date_of_birth, 
      :document_type, 
      :document_number
    )
  end

  def voluntario_update_params
    # Para actualizaciones solo permitimos los campos que se envían
    # y no requerimos que se envíen todos
    params.require(:voluntario).permit(
      :first_name, 
      :last_name, 
      :email, 
      :phone, 
      :date_of_birth, 
      :document_type, 
      :document_number
    )
  end

  def login_params
    params.require(:voluntario).permit(:identifier, :password)
  end
end
