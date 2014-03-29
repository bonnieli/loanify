IouApp::Application.routes.draw do
  get "welcome/index"

  ## SET ROOT
  root "welcome#index"

  get '/auth/:provider/callback', to: 'sessions#create'
  post '/welcome/post_transaction', to: 'welcome#post_transaction'

  get '/welcome/home'
  get '/welcome/home/:email', to: 'welcome#email'
  get '/welcome/create_transaction', to: 'welcome#create_transaction'
  get '/welcome/delete_transaction/:id', to: 'welcome#delete_transaction'
  get '/welcome/iou'
  get '/welcome/iou/rejected', to: 'welcome#iou_rejected'
  get '/welcome/iou/paid', to: 'welcome#iou_paid'
  get '/welcome/iou/unpaid', to: 'welcome#iou_unpaid'
  get '/welcome/uoi'
  get '/welcome/uoi/rejected', to: 'welcome#uoi_rejected'
  get '/welcome/uoi/paid', to: 'welcome#uoi_paid'
  get '/welcome/uoi/unpaid', to: 'welcome#uoi_unpaid'
  get '/welcome/paidback/:id/:d', to: 'welcome#paidback'
  get '/welcome/reject/:id', to: 'welcome#reject'
  get '/welcome/profile', to: 'welcome#profile'
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
