class AddWalletBalancesToAdminAndUsers < ActiveRecord::Migration[7.0]
  def change
    add_column :admins, :initial_wallet_balance, :decimal, precision: 10, scale: 2, default: 1000000.00
    add_column :users, :initial_wallet_balance, :decimal, precision: 10, scale: 2, default: 10000.00
  end
end
