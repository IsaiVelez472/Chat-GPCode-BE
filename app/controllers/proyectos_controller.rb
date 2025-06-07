class ProyectosController < ApplicationController
  # GET /proyectos
  def index
    @proyectos = Proyecto.all
    render json: @proyectos
  end

  # GET /proyectos/:id
  def show
    @proyecto = Proyecto.find(params[:id])
    render json: @proyecto
  rescue ActiveRecord::RecordNotFound
    render json: { error: 'Proyecto no encontrado' }, status: :not_found
  end
  
  # GET /proyectos/empresa/:company_id
  def by_company
    @proyectos = Proyecto.where(company_id: params[:company_id])
    render json: @proyectos
  end

  # POST /proyectos
  def create
    @proyecto = Proyecto.new(proyecto_params)

    if @proyecto.save
      render json: @proyecto, status: :created
    else
      render json: { errors: @proyecto.errors.full_messages }, status: :unprocessable_entity
    end
  end

  # PUT/PATCH /proyectos/:id
  def update
    @proyecto = Proyecto.find(params[:id])

    if @proyecto.update(proyecto_params)
      render json: @proyecto
    else
      render json: { errors: @proyecto.errors.full_messages }, status: :unprocessable_entity
    end
  rescue ActiveRecord::RecordNotFound
    render json: { error: 'Proyecto no encontrado' }, status: :not_found
  end

  # DELETE /proyectos/:id
  def destroy
    @proyecto = Proyecto.find(params[:id])
    @proyecto.destroy
    head :no_content
  rescue ActiveRecord::RecordNotFound
    render json: { error: 'Proyecto no encontrado' }, status: :not_found
  end

  private

  # Solo permitir los parámetros necesarios
  def proyecto_params
    params.require(:proyecto).permit(:title, :description, :location, :company_id, tags: [])
  end
end
