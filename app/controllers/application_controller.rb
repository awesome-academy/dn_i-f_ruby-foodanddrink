class ApplicationController < ActionController::Base
  before_action :set_locale
  protect_from_forgery with: :exception
  before_action :configure_permitted_parameters, if: :devise_controller?
  before_action :initializ_session
  include ProductsHelper

  rescue_from CanCan::AccessDenied do |_exception|
    flash[:danger] = t "no_permission"
    redirect_to root_url
  end

  protected

  def after_sign_in_path_for resource_or_scope
    if current_user&.admin?
      stored_location_for(resource_or_scope) || admin_root_path
    else
      stored_location_for(resource_or_scope) || root_path
    end
  end

  private

  def set_locale
    I18n.locale = params[:locale] || I18n.default_locale
  end

  def default_url_options
    {locale: I18n.locale}
  end

  def initializ_session
    session[:cart] ||= {}
  end

  protected

  def configure_permitted_parameters
    added_attrs = [:name, :email, :password,
                   :password_confirmation, :remember_me]
    devise_parameter_sanitizer.permit :sign_up, keys: added_attrs
    devise_parameter_sanitizer.permit :account_update, keys: added_attrs
  end
end
