require 'api_constraints'
RiseRp::Application.routes.draw do
  
  root 'pages#index'  

  resources :collections do
    collection do 
      get :import
    end
    resources :resources, controller: 'collections/resources' do
      collection do 
        get :import
      end
    end
  end

  resources :resources, controller: 'collections/resources' do
    resources :sections, controller: 'resources/sections' do
      collection do
        get :import
      end
    end
  end

  resources :sections, controller: 'resources/sections' do
    resources :content_units, controller: 'sections/content_units' do
      collection do
        get :import
      end
    end
  end

  resources :pages do
    collection do
      get :home
      get :help
    end
  end

  namespace :api, defaults: { format: :json } do
    scope module: :v1, constraints: ApiConstraints.new(version: 1, default: true) do
      get :full_text_search, param: :q, to: 'resources#search'
      resources :collections, param: :uuid, only: %i{index show} do
        resources :resources, only: %i{index}, controller: 'collections/resources' do
        end
      end
      resources :resources, param: :uuid, only: %i{index show} do
        member do
          get :metadata
        end
        resources :sections, only: %i{index}, controller: 'resources/sections'
      end
      resources :sections, param: :uuid, only: %i{index show} do
        member do
          get :metadata
        end
        resources :content_units, only: %i{index}, controller: 'sections/content_units' do
        end
      end
      resources :content_units, param: :uuid, only: %i{show} do
        member do
          get :metadata
        end
      end
    end
  end
end
