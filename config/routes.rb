Rails.application.routes.draw do
  mount Ckeditor::Engine => '/ckeditor'
  devise_for :users, controllers: {
    registrations: 'users/registrations'
  }
  root 'pages#home'
  # resources :posts
  resources :posts do
    resources :comments, only: [:create] # chỉ cần tạo (create) comment trong post
  end
end
