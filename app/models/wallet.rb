class Wallet < ApplicationRecord
  belongs_to :user
  belongs_to :admin

  def debit(amount)
    update(balance: balance - amount) if balance >= amount
  end

  def credit(amount)
    update(balance: balance + amount)
  end
end
