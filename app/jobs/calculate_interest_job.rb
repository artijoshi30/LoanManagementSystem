class CalculateInterestJob < ApplicationJob
  queue_as :default

  def perform(loan_id)
    loan = Loan.find(loan_id)
    total_loan_amount = loan.calculate_total_loan_amount
    loan.update(total_loan_amount: total_loan_amount)
  end
end
