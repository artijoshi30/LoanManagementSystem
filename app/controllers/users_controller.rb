class UsersController < ApplicationController
  before_action :authenticate_user!

  def index
    puts "Current User: #{current_user.inspect}"
    @user = current_user
    @loans = @user.loans
  end

  def create_loan
    binding.pry
    @loan = Loan.new(loan_params)
    @loan.user = current_user
    @loan.state = 'requested'

    if @loan.save
      redirect_to users_loan_requests_path(current_user), notice: 'Loan request submitted successfully.'
    else
      render :new_loan_request
    end
  end

  def new_loan_request
    @loan = current_user.loans.build(loan_params)
    @loan.state = 'requested'

    if @loan.save
      flash[:success] = 'Loan request created and is now in the requested state.'
      redirect_to user_dashboard_path
    else
      flash[:error] = 'Failed to create the loan request.'
      render :new_loan_request
    end
  end


  def confirm_loan_request
    @loan = current_user.loans.find(params[:loan_id])
    if @loan.approved?
      if @loan.confirm!
        flash[:success] = 'Loan request confirmed and is now in the open state.'
        redirect_to user_dashboard_path
      else
        flash[:error] = 'Failed to confirm the loan request.'
        redirect_to user_dashboard_path
      end
    else
      flash[:error] = 'Loan request is not in the approved state.'
      redirect_to user_dashboard_path
    end
  end

  def reject_loan_request
    @loan = current_user.loans.find(params[:loan_id])
    if @loan.requested?
      if @loan.reject!
        flash[:success] = 'Loan request rejected and is now in the rejected state.'
        redirect_to user_dashboard_path
      else
        flash[:error] = 'Failed to reject the loan request.'
        redirect_to user_dashboard_path
      end
    else
      flash[:error] = 'Loan request is not in the requested state.'
      redirect_to user_dashboard_path
    end
  end

  def repay_loan
    @loan = current_user.loans.find(params[:loan_id])

    if @loan.open?
      CalculateInterestJob.perform_later(@loan.id)
      DebitLoanAmountJob.perform_later(@loan.id)

      flash[:success] = 'Loan repayment initiated.'
      redirect_to user_dashboard_path
    else
      flash[:error] = 'Loan is not in the open state.'
      redirect_to user_dashboard_path
    end
  end

  private

  def loan_params
    params.require(:loan).permit(:amount, :interest_rate, :term)
  end


  def calculate_total_loan_amount(loan)
    time_since_opened = (Time.now - loan.created_at) / 60
    interest_rate = loan.interest_rate
    total_loan_amount = loan.amount + (loan.amount * (interest_rate / 100) * (time_since_opened / 525600))

    return total_loan_amount
  end
end
  