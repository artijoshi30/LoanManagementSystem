class AdminController < ApplicationController
  before_action :authenticate_admin!

  def index
    @admin = current_admin
    @loan_requests = Loan.where(state: 'requested')
  end

  def approve_loan_request
    @loan = Loan.find(params[:loan_id])
    if @loan.requested?
      new_interest_rate = params[:interest_rate].to_f || 0.05 
      @loan.interest_rate = new_interest_rate
      if @loan.approve!
        flash[:success] = 'Loan request approved.'
        redirect_to admin_index_path
      else
        flash[:error] = 'Failed to approve the loan request.'
        redirect_to admin_index_path
      end
    else
      flash[:error] = 'Loan request is not in the requested state.'
      redirect_to admin_index_path
    end
  end

  def reject_loan_request
    @loan = Loan.find(params[:loan_id])
    if @loan.requested?
      if @loan.reject!
        flash[:success] = 'Loan request rejected.'
        redirect_to admin_index_path
      else
        flash[:error] = 'Failed to reject the loan request.'
        redirect_to admin_index_path
      end
    else
      flash[:error] = 'Loan request is not in the requested state.'
      redirect_to admin_index_path
    end
  end

  def active_loans
    @active_loans = Loan.where(state: 'open')
  end

  def repaid_loans
    @repaid_loans = Loan.where(state: 'closed')
  end
end
