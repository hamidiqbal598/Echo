Rails.application.routes.draw do

  get '/', to: 'endpoints#index'

  resources :endpoints, defaults: { format: :json }

  # post '/:anything_else', to: 'endpoints#created_endpoint'
  match '/:anything_else', to: 'endpoints#created_endpoint',
        via: [:create, :patch, :get, :options, :post, :put, :delete, :copy, :head, :lock, :unlock, :PROPFIND]

  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
