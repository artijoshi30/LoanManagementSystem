class LoansController < ApplicationController
  before_action :authenticate_user!

  def create
    @loan = current_user.loans.build(loan_params)
    @loan.state = 'requested'

    if @loan.save
      redirect_to loans_path, notice: 'Loan request submitted successfully.'
    else
      render :new
    end
  end


  def request_loan
    @loan = current_user.loans.build(loan_params)
    @loan.state = 'requested'

    if @loan.save
      redirect_to loans_path, notice: 'Loan request submitted successfully.'
    else
      render :new
    end
  end

  def approve_loan
    @loan = Loan.find(params[:id])

    if current_user.admin? && @loan.requested?
      @loan.approve!(params[:interest_rate])
      redirect_to loans_path, notice: 'Loan request approved.'
    else
      redirect_to loans_path, alert: 'You are not authorized to perform this action.'
    end
  end

  def reject_loan
    @loan = Loan.find(params[:id])

    if current_user.admin? && @loan.requested?
      @loan.reject!
      redirect_to loans_path, notice: 'Loan request rejected.'
    else
      redirect_to loans_path, alert: 'You are not authorized to perform this action.'
    end
  end

  def confirm_loan
    @loan = Loan.find(params[:id])

    if current_user == @loan.user && @loan.approved?
      @loan.calculate_interest!
      @loan.open!
      
      redirect_to loans_path, notice: 'Loan confirmed.'
    else
      redirect_to loans_path, alert: 'You are not authorized to perform this action.'
    end
  end

  def repay_loan
    @loan = Loan.find(params[:id])

    if current_user == @loan.user && @loan.open?
      total_amount_to_repay = @loan.calculate_total_loan_amount
      
      if current_user.wallet.balance >= total_amount_to_repay
        
        @loan.close!
        redirect_to loans_path, notice: 'Loan repaid successfully.'
      else
        redirect_to loans_path, alert: 'Insufficient funds to repay the loan.'
      end
    else
      redirect_to loans_path, alert: 'You are not authorized to perform this action.'
    end
  end

  private

  def loan_params
   	params.require(:loan).permit(:amount, :interest_rate, :term)
  end
end
