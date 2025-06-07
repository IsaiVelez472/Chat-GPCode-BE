class ApplicationsController < ApplicationController
  # GET /applications
  def index
    @applications = Application.all.includes(user: {}, vacancy: :empresa)
    
    # Construir respuesta con datos de aplicaciones, usuarios y vacantes asociadas
    response = @applications.map do |application|
      application_data = application.as_json
      
      # Incluir datos del usuario
      user_data = {
        id: application.user.id,
        first_name: application.user.first_name,
        last_name: application.user.last_name,
        email: application.user.email,
        document_type: application.user.document_type,
        document_number: application.user.document_number
      }
      
      # Incluir datos de la vacante con información de la empresa
      vacancy_data = {
        id: application.vacancy.id,
        title: application.vacancy.title,
        description: application.vacancy.description,
        company_id: application.vacancy.company_id,
        project_id: application.vacancy.project_id,
        vacancies_count: application.vacancy.vacancies_count,
        expiration_date: application.vacancy.expiration_date
      }
      
      # Incluir datos de la empresa si está disponible
      if application.vacancy.empresa.present?
        company_data = {
          id: application.vacancy.empresa.id,
          nombre: application.vacancy.empresa.nombre,
          industria: application.vacancy.empresa.industria,
          correo: application.vacancy.empresa.correo,
          nit: application.vacancy.empresa.nit
        }
        vacancy_data['company'] = company_data
      end
      
      application_data['user'] = user_data
      application_data['vacancy'] = vacancy_data
      application_data
    end
    
    render json: response
  end

  # GET /applications/:id
  def show
    @application = Application.includes(vacancy: :empresa).find(params[:id])
    
    # Incluir datos del usuario
    user_data = {
      id: @application.user.id,
      first_name: @application.user.first_name,
      last_name: @application.user.last_name,
      email: @application.user.email,
      document_type: @application.user.document_type,
      document_number: @application.user.document_number
    }
    
    # Incluir datos de la vacante
    vacancy_data = {
      id: @application.vacancy.id,
      title: @application.vacancy.title,
      description: @application.vacancy.description,
      company_id: @application.vacancy.company_id,
      project_id: @application.vacancy.project_id,
      vacancies_count: @application.vacancy.vacancies_count,
      expiration_date: @application.vacancy.expiration_date
    }
    
    # Incluir datos de la empresa si está disponible
    if @application.vacancy.empresa.present?
      company_data = {
        id: @application.vacancy.empresa.id,
        nombre: @application.vacancy.empresa.nombre,
        industria: @application.vacancy.empresa.industria,
        correo: @application.vacancy.empresa.correo,
        nit: @application.vacancy.empresa.nit
      }
      vacancy_data['company'] = company_data
    end
    
    application_data = @application.as_json
    application_data['user'] = user_data
    application_data['vacancy'] = vacancy_data
    
    render json: application_data
  rescue ActiveRecord::RecordNotFound
    handle_record_not_found(nil, 'Postulación no encontrada')
  end

  # GET /applications/user/:user_id
  def by_user
    @applications = Application.where(user_id: params[:user_id])
                              .includes(vacancy: :empresa)
    
    # Construir respuesta con datos de aplicaciones y vacantes asociadas
    response = @applications.map do |application|
      application_data = application.as_json
      
      # Incluir datos de la vacante
      vacancy_data = {
        id: application.vacancy.id,
        title: application.vacancy.title,
        description: application.vacancy.description,
        company_id: application.vacancy.company_id,
        project_id: application.vacancy.project_id,
        vacancies_count: application.vacancy.vacancies_count,
        expiration_date: application.vacancy.expiration_date
      }
      
      # Incluir datos de la empresa si está disponible
      if application.vacancy.empresa.present?
        company_data = {
          id: application.vacancy.empresa.id,
          nombre: application.vacancy.empresa.nombre,
          industria: application.vacancy.empresa.industria,
          correo: application.vacancy.empresa.correo,
          nit: application.vacancy.empresa.nit
        }
        vacancy_data['company'] = company_data
      end
      
      application_data['vacancy'] = vacancy_data
      application_data
    end
    
    render json: response
  end

  # GET /applications/vacancy/:vacancy_id
  def by_vacancy
    @applications = Application.where(vacancy_id: params[:vacancy_id])
                              .includes(:user, vacancy: :empresa)
    
    # Construir respuesta con datos de aplicaciones y usuarios asociados
    response = @applications.map do |application|
      application_data = application.as_json
      
      # Incluir datos del usuario
      user_data = {
        id: application.user.id,
        first_name: application.user.first_name,
        last_name: application.user.last_name,
        email: application.user.email,
        document_type: application.user.document_type,
        document_number: application.user.document_number
      }
      
      application_data['user'] = user_data
      application_data
    end
    
    render json: response
  end
  
  # GET /applications/company/:company_id
  def by_company
    # Buscar aplicaciones donde la vacante tenga el company_id especificado
    @applications = Application.joins(:vacancy)
                              .where(vacantes: { company_id: params[:company_id] })
                              .includes(:user, vacancy: :empresa)
    
    # Construir respuesta con datos de aplicaciones, usuarios y vacantes
    response = @applications.map do |application|
      application_data = application.as_json
      
      # Incluir datos del usuario
      user_data = {
        id: application.user.id,
        first_name: application.user.first_name,
        last_name: application.user.last_name,
        email: application.user.email,
        document_type: application.user.document_type,
        document_number: application.user.document_number
      }
      
      # Incluir datos de la vacante
      vacancy_data = {
        id: application.vacancy.id,
        title: application.vacancy.title,
        description: application.vacancy.description,
        company_id: application.vacancy.company_id,
        project_id: application.vacancy.project_id,
        vacancies_count: application.vacancy.vacancies_count,
        expiration_date: application.vacancy.expiration_date
      }
      
      # Incluir datos de la empresa si está disponible
      if application.vacancy.empresa.present?
        company_data = {
          id: application.vacancy.empresa.id,
          nombre: application.vacancy.empresa.nombre,
          industria: application.vacancy.empresa.industria,
          correo: application.vacancy.empresa.correo,
          nit: application.vacancy.empresa.nit
        }
        vacancy_data['company'] = company_data
      end
      
      application_data['user'] = user_data
      application_data['vacancy'] = vacancy_data
      application_data
    end
    
    render json: response
  end

  # POST /applications
  def create
    @application = Application.new(application_params)

    if @application.save
      render json: @application, status: :created
    else
      handle_validation_errors(@application)
    end
  end

  # PATCH/PUT /applications/:id
  def update
    @application = Application.find(params[:id])

    if @application.update(application_params)
      render json: @application
    else
      handle_validation_errors(@application)
    end
  rescue ActiveRecord::RecordNotFound
    handle_record_not_found(nil, 'Postulación no encontrada')
  end

  # DELETE /applications/:id
  def destroy
    @application = Application.find(params[:id])
    @application.destroy
    head :no_content
  rescue ActiveRecord::RecordNotFound
    handle_record_not_found(nil, 'Postulación no encontrada')
  end

  private

  # Solo permitir los parámetros necesarios
  def application_params
    params.require(:application).permit(:user_id, :vacancy_id, :status)
  end
end
