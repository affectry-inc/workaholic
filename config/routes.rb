Rails.application.routes.draw do

  resources :special_holidays
  resources :special_holiday_ctgrs
  resources :extra_holidays
  # get 'report_submissions/index'

  # get 'report_requests/index'

  # get 'report_requests/edit'

  root 'static_pages#home'
  get 'contact' => 'static_pages#contact'
  get 'signup' => 'users#new'
  get    'login'   => 'sessions#new'
  post   'login'   => 'sessions#create'
  delete 'logout'  => 'sessions#destroy'
  resources :timecards do
    member do
      post 'workflow'
      post 'apply_all'
      post 'approve_all'
    end
  end
  get 'paid_holidays' => 'paid_holidays#index'
  # get 'reports' => 'reports#index'
  # get 'reports/:id/edit' => 'reports#edit', as: :edit_report
  resources :reports
  get 'report_download' => 'report_submissions#download'
  get 'my_reports' => 'reports#my_reports'
  # get 'report_requests' => 'report_requests#index'
  # get 'report_requests/:id/edit' => 'report_requests#edit', as: :edit_report_request
  # resources :report_requests
  # get 'report_submissions' => 'report_submissions#index'
  resources :report_submissions do
    member do
      post 'approve'
    end
  end
  resources :users


  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  # root 'welcome#index'

  # Example of regular route:
  #   get 'products/:id' => 'catalog#view'

  # Example of named route that can be invoked with purchase_url(id: product.id)
  #   get 'products/:id/purchase' => 'catalog#purchase', as: :purchase

  # Example resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Example resource route with options:
  #   resources :products do
  #     member do
  #       get 'short'
  #       post 'toggle'
  #     end
  #
  #     collection do
  #       get 'sold'
  #     end
  #   end

  # Example resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Example resource route with more complex sub-resources:
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', on: :collection
  #     end
  #   end

  # Example resource route with concerns:
  #   concern :toggleable do
  #     post 'toggle'
  #   end
  #   resources :posts, concerns: :toggleable
  #   resources :photos, concerns: :toggleable

  # Example resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end
end
