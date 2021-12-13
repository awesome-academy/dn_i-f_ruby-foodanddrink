class Admin::AdminsController < ApplicationController
  before_action :logged_in_user, :is_admin?
  layout "admin"

  def index; end

  private

  def is_admin?
    return if current_user.admin?

    flash[:danger] = t "no_permission"
    redirect_to login_path
  end
end
