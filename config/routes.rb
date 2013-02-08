Stry::Application.routes.draw do
  devise_for :users

  resources :editor, only: [:index]
  namespace :editor do
    resources :stories
    resources :scenes
    resources :blocks do
      collection do
        get :klass_select_markup
      end
    end
    resources :attachments
  end

  resources :stories, only: [:index, :show]

  root :to => 'stories#index'

end
