class Admin::ProductsController < Admin::AdminsController
  def index
    @title = t "admin_product.title"
    @products = Product.recent.page(params[:page])
                       .per(Settings.page_record_medium_14)
  end
<<<<<<< HEAD
=======

  def show
    @title = t "show_product_admin.title"
    @product = Product.find_by id: params[:id]
    return if @product

    flash[:danger] = t "not_found"
    redirect_to admin_products_path
  end
>>>>>>> [Admin] Detail product
end
