Rails.application.routes.draw do
  get 'welcome/index'

  get   'resource/show_by_name/:id' => 'resource#show_by_name'
  get   'category/show_by_name/:id' => 'category#show_by_name'
  get   'category/tree/:id' => 'category#tree'
  get   'category/:id' => 'category#show'
  get   'resource/:id' => 'resource#show'
  resources :category, except: [:show]
  resources :resource, except: [:show]
  resources :welcome, only: [:index]

  resources :user
  resources :session, only: [:new, :create, :destroy]
  resources :tree
  post  '/logout' => 'session#destroy'
  patch 'category/update_parent/:id' => 'category#update_parent'
  patch 'resource/update_parent/:id' => 'resource#update_parent'

  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  root 'welcome#index'

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
