SS::Application.routes.draw do
  Gws::Schedule::Initializer

  concern :plans do
    get :events, on: :collection
    get :print, on: :collection
    get :popup, on: :member
    get :copy, on: :member
    get :delete, on: :member
    delete action: :destroy_all, on: :collection
  end

  concern :export do
    get :download, on: :collection
  end

  concern :deletion do
    get :delete, on: :member
    delete action: :destroy_all, on: :collection
  end

  gws "schedule" do
    get 'all_groups' => 'groups#index'
    get 'facilities' => 'facilities#index'
    get 'facilities/print' => 'facilities#print'
    get 'search' => redirect { |p, req| "#{req.path}/users" }, as: :search
    get 'search/users' => 'search/users#index', as: :search_users
    get 'search/times' => 'search/times#index', as: :search_times
    get 'search/reservations' => 'search/reservations#index', as: :search_reservations
    get 'csv' => 'csv#index', as: :csv
    post 'import_csv' => 'csv#import', as: :import_csv

    get '/' => redirect { |p, req| "#{req.path}/plans" }, as: :main
    resources :plans, concerns: [:plans, :export]
    resources :list_plans, concerns: :plans
    resources :user_plans, path: 'users/:user/plans', concerns: :plans
    resources :group_plans, path: 'groups/:group/plans', concerns: :plans
    resources :custom_group_plans, path: 'custom_groups/:group/plans', concerns: :plans
    resources :facility_plans, path: 'facilities/:facility/plans', concerns: [:plans, :export]
    resources :holidays, concerns: :plans
    resources :comments, path: ':plan_id/comments', only: [:create, :edit, :update, :destroy], concerns: :deletion
    resource :attendance, path: ':plan_id/:user_id/attendance', only: [:edit, :update]
    resource :approval, path: ':plan_id/:user_id/approval', only: [:edit, :update]

    namespace 'todo' do
      get '/' => redirect { |p, req| "#{req.path}/readables" }, as: :main
      resources :readables, concerns: :plans do
        match :finish, on: :member, via: %i[get post]
        match :revert, on: :member, via: %i[get post]
        match :disable, on: :member, via: %i[get post]
        post :finish_all, on: :collection
        post :revert_all, on: :collection
        post :disable_all, on: :collection
      end
      resources :trashes, concerns: :deletion do
        match :active, on: :member, via: %i[get post]
        post :active_all, on: :collection
      end
    end

    resources :categories, concerns: :plans
    resource :user_setting, only: [:show, :edit, :update]
  end
end
