Health::Application.routes.draw do
  root :to => "home#index"

  ActiveAdmin.routes(self)
  devise_for :admin_users, ActiveAdmin::Devise.config

  devise_for :users, :path => "user", :path_names => {:sign_in => "login", :sign_out => "logout", :sign_up => "signup"}

  scope "client" do
    get '(:platform)/recent', :to => "software_packages#recent"
    get '(:platform)' , :to => "software_packages#index"
  end


  resources :notifications do
    collection do
      get :from_date
    end
  end

  scope "/measurements" do
    [:temperatures, :cardiograms, :bloodpressures, :glucoses, :oxygens, :weights].each do |res|
      resources res, :controller => "measurements",
                :measurement_name => res,
                :as => "measurements_#{res}"
    end
  end

  resources :patients do
    collection do
      get 'account/:account_type/(:account_code)', :action => :account, :as => :account
      post :register
      post :add_account
    end
    member do
      get :enroll
      get :unlist
    end

    resources :notifications
    [:temperatures, :cardiograms, :bloodpressures, :glucoses].each do |res|
      resources res, :measurement_name => res,
                :controller => :measurements,
                :path => 'measurements/'+res.to_s,
                :as => "measurements_#{res}"
    end
    [:temperature_thresholds, :cardiogram_thresholds, :bloodpressure_thresholds, :glucose_thresholds].each do |res|
      resources res, :threshold_name => res,
                :controller => :measurement_thresholds,
                :path => 'measurement_thresholds/'+res.to_s,
                :as => "#{res}"
    end

    match 'measurements/last' => 'measurements#last'

  end

  controller :home, :action => 'show', :via => :get do
    match '/', :id => 'index'
    match '/contacts', :id => 'contacts'
    match '/about', :id => 'about'
    match '/privacy', :id => 'privacy'
    match '/terms', :id => 'terms'
  end

  resources :medical_device_lists, only: [:index, :create, :show, :update, :destroy]

  # API v2
  namespace :api_v2, path: 'api/v2' do
    scope '(:locale)', locale: /en|ru/ do
      devise_for :doctors
      devise_for :patients

      # Patients namespace
      namespace :patient do
        namespace :measurements do
          resources :bloodpressures, only: [:index, :create]
          resources :cardiograms, only: [:index, :create]
          resources :glucoses, only: [:index, :create]
          resources :oxygens, only: [:index, :create]
          resources :temperatures, only: [:index, :create]
          resources :weights, only: [:index, :create]
        end
      end

      # Doctors namespace
      namespace :doctor do
        resources :patients, only: [:index] do
          namespace :measurements do
            resources :bloodpressures, only: [:index, :create]
            resources :cardiograms, only: [:index, :create]
            resources :glucoses, only: [:index, :create]
            resources :oxygens, only: [:index, :create]
            resources :temperatures, only: [:index, :create]
            resources :weights, only: [:index, :create]
          end
        end
      end
    end
  end
end
