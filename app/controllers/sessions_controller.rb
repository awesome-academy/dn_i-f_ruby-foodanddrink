class SessionsController < ApplicationController
  def new; end

  def create
    user = User.find_by email: params[:session][:email].downcase
    if user&.authenticate(params[:session][:password])
      create_login
    else
      flash[:danger] = t "invalid_email_password"
      render :new
    end
  end

  def destroy
    session[:cart] = nil
    log_out
    flash[:success] = t "logged_out"
    redirect_to login_path
  end

  private

  def create_login
    user = User.find_by email: params[:session][:email].downcase

    flash[:success] = t "login_success"
    session[:cart] = {}
    log_in user
    return redirect_to admin_root_url if user.admin?

    redirect_to home_path
  end
end
