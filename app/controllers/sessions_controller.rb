class SessionsController < ApplicationController
  skip_before_action :require_login, only: [:new, :create]
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

  def destroy
    log_out
    flash[:success] = t "logged_out"
    redirect_to login_path
  end
end
