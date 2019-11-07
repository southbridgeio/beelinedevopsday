Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  root 'pastes#new'
  get 'help' => 'pastes#help'
  resources :pastes, path: 'p'
  post 'paste' => 'pastes#create'
  post 'paste-file' => 'pastes#create_from_file'
  get ':id' => 'pastes#show'
end
