Rails.application.routes.draw do
  resources :calendar_events
  resources :bags
  resources :subscriptions
  root 'posts#home'

  resources :competition_galleries do
    member do
      delete :delete_photo
    end
  end
  get 'admin/competition_galleries' => 'competition_galleries#admin'
  post 'competition_galleries/new' => 'competition_galleries#create'
  patch 'competition_galleries/:id/edit' => 'competition_galleries#update'
  post 'competition_galleries/:id' => 'competition_galleries#delete_photo'

  resources :users, only: [:index, :edit, :update]
  get 'users/import' => 'users#import'
  post 'users/import' => 'users#import_from_wca'

  # To not ruin our pagerank, we need a "/news" routes with slugs, so that old links keep working
  resources :news, :controller => "posts"
  get '/news/tag/:tag' => 'posts#tag_index', :as => :posts_by_tag
  # Some slug have slashes, we need a globbing routes (and an appropriate path helper too)
  get '/news/*id' => 'posts#show', :as => 'news_slug', :format => false
  resources :subscriptions, only: [:index, :destroy]
  resources :tags, only: [:index, :edit, :update]
  resources :hardwares

  get '/members' => 'subscriptions#show'
  get '/members/ranking/333mbf/average', to: redirect('/members/ranking/333mbf/single')
  get '/members/ranking/:event_id/:format' => 'subscriptions#ranking', as: :ranking
  get '/members/medal_collection' => 'subscriptions#medal_collection'
  get '/association/subscribe' => 'subscriptions#subscribe'
  get '/subscriptions/new' => 'subscriptions#new'
  get '/subscriptions/create' => 'subscriptions#create'

  get '/my_competitions' => 'competitions#my_competitions'
  get '/upcoming_comps' => 'competitions#upcoming_comps'
  get '/upcoming_champs' => 'competitions#manage_big_champs'
  post '/update_champs' => 'competitions#update_big_champs'

  resources :competitions, only: [:index]
  get 'competitions/official/:competition_id/registrations' => 'competitions#show_registrations', :as => :competition_registrations
  get 'competitions/:slug' => 'competitions#show_competition_page', :as => 'old_competitions'

  get '/profile' => 'users#edit'

  get '/wca_callback' => 'sessions#create'
  get '/signin' => 'sessions#new', :as => :signin
  post '/signin_with_wca' => 'sessions#signin_with_wca', :as => :signin_with_wca
  get '/signout' => 'sessions#destroy', :as => :signout
end
