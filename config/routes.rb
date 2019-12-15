Rails.application.routes.draw do
  get 'sessions/new'
  root 'users#home'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  ##users
  get  'users/publishers' => 'users#index',as:"publishers"
  get  'signup' => 'users#new',as:"signup"
  post 'signup' => 'users#create',as:"create_user"
  get  'users/:id' => 'users#show',as:"user"
  get  'users/:id/edit' => 'users#edit',as:"edit_user"
  patch  'users/:id' => 'users#update',as:"update_user"
  delete 'users/:id',  to: 'users#destroy',as:"delete_user"
  ##session
  get   'login',   to: 'sessions#new'
  post   'login',   to: 'sessions#create'
  delete 'logout',  to: 'sessions#destroy'

  ##article
  # get  'articles' => 'user_articles#index',as:"user_articles"
  # get  'articles/:id' => 'user_articles#show',as:"user_article"
  # get  'articles/' => 'user_articles#show',as:"user_article"
  resources :user_articles

  ##vocabs
  post 'user_articles/:id', to: 'vocabs#create',as: 'create_vocab'
  delete 'user_articles', to: 'vocabs#destroy',as: 'destroy_vocab'
end
