class ProductsController < ApplicationController
  skip_before_action :require_login, only: [:home, :show]

  def home
    @products = Product.all.page(params[:page]).per(Settings.page_record_medium)
                       .recent
  end

  def show
    @product = Product.find_by id: params[:id]
    return if @product.present?

    flash[:warning] = t "not_found"
    redirect_to home_path
  end
end
