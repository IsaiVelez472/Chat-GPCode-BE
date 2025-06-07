class VacantesController < ApplicationController
  # GET /vacantes
  def index
    @vacantes = Vacante.all.includes(:proyecto, :empresa)
    
    # Construir respuesta con datos de vacantes, sus proyectos y empresas asociadas
    response = @vacantes.map do |vacante|
      proyecto_data = {
        id: vacante.proyecto.id,
        title: vacante.proyecto.title,
        description: vacante.proyecto.description,
        location: vacante.proyecto.location,
        tags: vacante.proyecto.tags
      }
      
      # Añadir datos de la empresa si existe
      empresa_data = nil
      if vacante.empresa.present?
        empresa_data = {
          id: vacante.empresa.id,
          nombre: vacante.empresa.nombre,
          industria: vacante.empresa.industria,
          correo: vacante.empresa.correo,
          nit: vacante.empresa.nit
        }
      end
      
      vacante_data = vacante.as_json
      vacante_data['proyecto'] = proyecto_data
      vacante_data['empresa'] = empresa_data
      vacante_data
    end
    
    render json: response
  end

  # GET /vacantes/:id
  def show
    @vacante = Vacante.find(params[:id])
    
    # Incluir datos del proyecto asociado
    proyecto = @vacante.proyecto
    proyecto_data = {
      id: proyecto.id,
      title: proyecto.title,
      description: proyecto.description,
      location: proyecto.location,
      tags: proyecto.tags
    }
    
    # Incluir datos de la empresa asociada si existe
    empresa_data = nil
    if @vacante.empresa.present?
      empresa_data = {
        id: @vacante.empresa.id,
        nombre: @vacante.empresa.nombre,
        industria: @vacante.empresa.industria,
        correo: @vacante.empresa.correo,
        nit: @vacante.empresa.nit
      }
    end
    
    vacante_data = @vacante.as_json
    vacante_data['proyecto'] = proyecto_data
    vacante_data['empresa'] = empresa_data
    
    render json: vacante_data
  rescue ActiveRecord::RecordNotFound
    render json: { error: 'Vacante no encontrada' }, status: :not_found
  end
  
  # GET /vacantes/empresa/:company_id
  def by_company
    @vacantes = Vacante.where(company_id: params[:company_id])
                      .includes(:proyecto, :empresa)
    
    # Construir respuesta con datos de vacantes, sus proyectos y empresas asociadas
    response = @vacantes.map do |vacante|
      proyecto_data = {
        id: vacante.proyecto.id,
        title: vacante.proyecto.title,
        description: vacante.proyecto.description,
        location: vacante.proyecto.location,
        tags: vacante.proyecto.tags
      }
      
      # Añadir datos de la empresa si existe
      empresa_data = nil
      if vacante.empresa.present?
        empresa_data = {
          id: vacante.empresa.id,
          nombre: vacante.empresa.nombre,
          industria: vacante.empresa.industria,
          correo: vacante.empresa.correo,
          nit: vacante.empresa.nit
        }
      end
      
      vacante_data = vacante.as_json
      vacante_data['proyecto'] = proyecto_data
      vacante_data['empresa'] = empresa_data
      vacante_data
    end
    
    render json: response
  end

  # POST /vacantes
  def create
    @vacante = Vacante.new(vacante_params)

    if @vacante.save
      render json: @vacante, status: :created
    else
      render json: { errors: @vacante.errors.full_messages }, status: :unprocessable_entity
    end
  end

  # PUT/PATCH /vacantes/:id
  def update
    @vacante = Vacante.find(params[:id])

    if @vacante.update(vacante_params)
      render json: @vacante
    else
      render json: { errors: @vacante.errors.full_messages }, status: :unprocessable_entity
    end
  rescue ActiveRecord::RecordNotFound
    render json: { error: 'Vacante no encontrada' }, status: :not_found
  end

  # DELETE /vacantes/:id
  def destroy
    @vacante = Vacante.find(params[:id])
    @vacante.destroy
    head :no_content
  rescue ActiveRecord::RecordNotFound
    render json: { error: 'Vacante no encontrada' }, status: :not_found
  end

  private

  # Solo permitir los parámetros necesarios
  def vacante_params
    params.require(:vacante).permit(:company_id, :project_id, :title, :description, :vacancies_count, :image, :expiration_date, tags: [])
  end
end
