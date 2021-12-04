class SessionsController < ApplicationController
  def new; end

  def create
    user = User.find_by email: params[:session][:email].downcase
    if user&.authenticate(params[:session][:password])
      flash[:success] = t "login_success"
      log_in user
      redirect_to home_path
    else
      flash[:danger] = t "invalid_email_password"
      render :new
    end
  end
end
