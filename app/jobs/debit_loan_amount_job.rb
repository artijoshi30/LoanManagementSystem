class DebitLoanAmountJob < ApplicationJob
  queue_as :default

  def perform(loan_id)
    loan = Loan.find(loan_id)
    if loan.user.wallet.balance >= loan.total_loan_amount
      loan.user.wallet.debit(loan.total_loan_amount)
      loan.admin.wallet.credit(loan.total_loan_amount)
      loan.close!
    else
    end
  end
end
