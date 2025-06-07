Rails.application.routes.draw do
  # Health check endpoint
  get 'health', to: 'health#check'
  
  # Rutas para voluntarios
  resources :voluntarios, only: [:index, :create, :update]
  get 'voluntarios/documento/:document_type/:document_number', to: 'voluntarios#show_by_document'
  post 'voluntarios/login', to: 'voluntarios#login'
  
  # Rutas para empresas
  resources :empresas, only: [:index, :show, :create, :update]
  get 'empresas/nit/:nit', to: 'empresas#show_by_nit'
  post 'empresas/login', to: 'empresas#login'

  # Rutas para proyectos
  resources :proyectos
  get 'proyectos/empresa/:company_id', to: 'proyectos#by_company'
  
  # Rutas para vacantes
  resources :vacantes
  get 'vacantes/empresa/:company_id', to: 'vacantes#by_company'
  
  # Rutas para applications (postulaciones)
  resources :applications
  get 'applications/user/:user_id', to: 'applications#by_user'
  get 'applications/vacancy/:vacancy_id', to: 'applications#by_vacancy'

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

end
