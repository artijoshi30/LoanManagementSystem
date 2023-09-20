Rails.application.routes.draw do
  root "users#index"
  devise_for :admins
  devise_for :users

  resources :users, only: [:index] do
    member do
      get 'new_loan_request'
      put 'confirm_loan_request'
      put 'reject_loan_request'
      put 'repay_loan'
      post 'create_loan'
    end
  end

  namespace :admin do
    resources :admin, only: [:index] do
      member do
        put 'approve_loan_request'
        put 'reject_loan_request'
      end
    end

    get 'active_loans', to: 'admin#active_loans'
    get 'repaid_loans', to: 'admin#repaid_loans'
  end

    resources :loans, only: [:index, :new, :create] do
      member do
        post 'approve_loan'
        post 'reject_loan'
        post 'confirm_loan'
        post 'repay_loan'
      end
    end
end

