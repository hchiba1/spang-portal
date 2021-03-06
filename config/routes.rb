Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root to: 'library#index'
  get 'library/search', to: 'library#search_template', as: 'library_search_template'
  resources :library, only: [:index, :show]
  get "library/:library_id/:template_id", to: 'library#show_template', as: 'library_show_template', constraints: { template_id: /[^\/]+/ }
  namespace :api do
    get 'search', to: 'library#search_template', as: 'library_search_template'
    get 'incremental_search', to: 'library#incremental_search', as: 'library_incremental_search'
    resources :library, only: [:index, :show]
    get 'library/:library_id/:template_id', to: 'library#query_template', as: 'library_query_template'
  end
end
