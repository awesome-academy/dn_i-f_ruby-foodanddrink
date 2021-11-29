class Admin::ProductsController < Admin::AdminsController
  def index
    @title = t "admin_product.title"
    @products = Product.recent.page(params[:page])
                       .per(Settings.page_record_medium_14)
  end
end
