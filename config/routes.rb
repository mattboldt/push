Push::Application.routes.draw do

  # redirect traffic to root
  constraints subdomain: 'www' do
    get ':any', to: redirect(subdomain: nil, path: '/%{any}'), any: /.*/
  end

  resources :authentications

  # Devise Authentication
  devise_scope :user do
    get "/users/sign_up" => redirect("/")
    get "/users/sign_in" => redirect("/")
  end
  devise_for :users, :controllers => { :sessions => "users/sessions", :registrations => 'registrations' }



  # Index of posts & paginated posts
  get '/page/:page', :controller => 'posts', :action => 'index'
  root :to => "posts#index"

  # Usernames under /@/
  resources :users, :path => "/@/" do
    # User settings
    get "settings/" => "users/settings#index"

    # Main Posts
    resources :posts, :controller => "users/posts", :path => "/" do
      post "pull", :controller => "users/posts", :action => "pull"
    end
  end

  # Markdown preview post request
  post "/post/preview", to: "users/posts#preview"
  patch "/post/preview", to: "users/posts#preview"

  # Omniauth w/ Github
  get "/auth/:provider/callback" => 'authentications#create'
  get "/auth/failure" => "authentications#failure"

  # User setup
  get "/setup" => "home#setup"

  # REST GitHub stuff
  namespace "rest" do
    post "git-repo-setup", action: "git_repo_setup"

    # errors
    # get "/404" => "errors#not_found"
    # get "/500" => ""
  end


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
