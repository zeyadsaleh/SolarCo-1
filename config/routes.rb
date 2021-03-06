Rails.application.routes.draw do
  resources :resources
  get 'notification/index'
  mount ActionCable.server => '/cable'
  
  devise_for :admin_users, ActiveAdmin::Devise.config
  ActiveAdmin.routes(self)
  # mount RailsAdmin::Engine => '/admin', as: 'rails_admin'
  root to: 'admin/dashboard#index'
  
  resources :contacts
  resources :posts
  resources :users, only: [:create, :update, :destroy]
  resources :offers

  mount_devise_token_auth_for 'User', at: 'user/auth'
  mount_devise_token_auth_for 'Contractor', at: 'contractor/auth'
  as :contractor do
    # Define routes for Contractor within this block.
  end

  ######## Calculations Routes #########
  post 'geocoder', to: 'geocoder#getLocation' 
  get 'test', to: 'geocoder#test' 
  resources :calculations, only: [:index, :show] 
  ###################################################
  
  ######### Systems Routes #########
  resources :systems, only: [:index, :create, :destroy] 
  ###################################################

  ######### Chat Routes #########
  get 'messages/:user_id/:contractor_id', to: 'messages#index'
  get 'chatrooms/clients/:id', to: 'chatrooms#clientChats'
  get 'chatrooms/contractors/:id', to: 'chatrooms#contractorChats'
  ###################################################

  ######### ReviewsRoutes #########
  get 'offer_rates/per_contractor/:id', to: 'offer_rates#index'
  get 'offer_reviews/per_contractor/:id', to: 'offer_reviews#index'
  resources :offer_rates, only: [:create, :show, :update] 
  resources :offer_reviews, only: [:create, :show, :update] 
  ###################################################

  ######### TutorailsRoutes #########
  get 'tutorials/categories/:id', to: 'tutorials#indexCategory'
  get 'tutorials/contractors/:id', to: 'tutorials#indexContractor'
  resources :tutorials
  resources :categories
  get 'comments/tutorial/:id', to: 'comments#indexTutorial'
  resources :comments
  get 'likes/tutorial/:id', to: 'likes#indexTutorial'
  resources :likes
  get 'favorites/user/:id', to: 'favorites#indexUser' 
  resources :favorites
  ###################################################

  ######## Clients Routes #########
  put 'clients/avatar/:id', to: 'clients#updateAvatar'
  resources :clients, only: [:show, :update]
  # get 'clients/:id', to: 'clients#show'
  # put 'clients/:id', to: 'clients#update'
  ###################################################

  ######## Contractor Routes #########
  put 'contractors/avatar/:id', to: 'contractors#updateAvatar'
  resources :contractors, only: [:show, :update]
  # get 'contractors/:id', to: 'contractors#show'
  # put 'contractors/:id', to: 'contractors#update'
  ###################################################

  ######## offers Route to get all offers on post #########
  get 'offers/post/:post_id', to: 'offers#getOffers'
  ###################################################
  get 'notifications', to: 'notification#index'
  get 'notifications/update', to: 'notification#updateAll'
  get 'notifications/count', to: 'notification#getCount'


  ######## contact us create route#########
  post 'contacts', to: 'contacts#create'
  ###################################################
end

