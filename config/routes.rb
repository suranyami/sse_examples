SseExamples::Application.routes.draw do
  resources :posts do
    collection do
      get :live
    end
  end
  root to: 'posts#index'
end
