SS::Application.routes.draw do
  Gws::Memo::Initializer

  concern :deletion do
    get :delete, :on => :member
    delete action: :destroy_all, on: :collection
  end

  gws 'memo' do
    resources :messages, concerns: :deletion do
      collection do
        put :set_seen
        put :unset_seen
        put :set_star
        put :unset_star
        put :move
        put :copy
        delete :empty
      end
      member do
        get :download
        get :parts, path: 'parts/:section', format: false, section: /[^\/]+/
        get :header_view
        get :source_view
        put :set_seen
        put :unset_seen
        put :set_star
        put :unset_star
        put :move
        put :copy
        get :reply
        get :reply_all
        get :forward
      end
    end
  end
end
