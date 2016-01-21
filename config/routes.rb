Rails.application.routes.draw do

  root 'gamelobbies#index'
  devise_for :users, :controllers => { :omniauth_callbacks => "omniauth_callbacks", :registrations => "registrations" }

  get 'leaderboard/index'
  delete '/gamelobbies', to: 'gamelobbies#index'

  resources :bombermen
  resources :gamechats
  
 # post 'gamelobbies/create', to: 'gamelobbies#create_game'
  get 'gamelobbies/join/:id', to: 'gamelobbies#join_with_link'
  post 'gamelobbies/join', to: 'gamelobbies#join'
  post 'gamelobbies/leave', to: 'gamelobbies#leave'
  post '/gamelobbies/changethumbnail', to: 'gamelobbies#change_thumbnail'
  post '/gamelobbies/updatemap', to: 'gamelobbies#update_map'
  post 'gamelobbies/start/:id', to: 'gamelobbies#start_game'
  get 'gamelobbies/channelname/:id', to: 'gamelobbies#get_channel_name'
  resources :gamelobbies

  get 'bombermen/show/:id', to: 'bombermen#show'
  get 'bombermen/game/:id', to: 'bombermen#get_game'
  post 'bombermen/game/leave/:id', to: 'bombermen#leave'
  post 'bombermen/game/winner/:id', to: 'bombermen#set_winner'
  get 'bombermen/index'
  post 'bombermen/index', to: 'bombermen#perform_action'


  get 'login/index'
  get 'gamechats/index'

  get 'chat/index'
  post 'chat/index', to: 'chat#send_msg'
  post 'chat/create', to: 'chat#create'
  resources :chat
  post 'gamechats/sendMessage', to: 'gamechats#send_message'
  resources :gamechats

  #create a row on bomberman table with the gamelobby id
  # get 'bombermen/index/:lobbyid', to: 'bombermen#create'
  get 'bombermen/index/:lobbyid', to: 'bombermen#index'

  post 'bombermen/adduser/:lobbyid/:username', to: 'bombermen#add_user'
  get 'bombermen/getusers/:lobbyid', to: 'bombermen#get_users'
  post 'bombermen/sendMovement', to: 'bombermen#broadcast_out'

  post 'chat/index', to: 'chat#send_msg'
  get 'about', :to => 'welcome#about'
  get 'welcome/index'
  get 'welcome/login', :to => redirect('../login.html.erb')

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
