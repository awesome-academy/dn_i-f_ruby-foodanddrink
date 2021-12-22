require "rails_helper"

RSpec.describe Admin::ProductsController, type: :controller do
   describe "GET #index" do
    context "when not log in" do
      before do
        get :index, params: {locale: I18n.locale}
      end

      it "redirect to login_url" do
        expect(response).to redirect_to new_user_session_path
      end
    end

    describe "when log in" do
      context "when not permission" do
        let!(:user) {FactoryBot.create :user, role: :user}
        before do
          sign_in user
          get :index, params: {locale: I18n.locale}
        end

        it "display flash danger" do
          expect(flash[:danger]).to eq I18n.t("no_permission")
        end
        it "redirect to login_path" do
          expect(response).to redirect_to root_url
        end
      end

      context "when has permission, sort create_order DESC" do
        let!(:user) {FactoryBot.create :user, role: :admin}
        let!(:product_1) {FactoryBot.create :product, name: "Nước ép"}
        let!(:product_2) {FactoryBot.create :product}
        let!(:product_3) {FactoryBot.create :product}
        before do
          sign_in user
          get :index
        end

        it "assigns orders" do
          expect(assigns(:products)).to eq ([product_3,product_2, product_1])
        end
        it "render template index admin product" do
          expect(response).to render_template "admin/products/index"
        end
      end
    end
  end
end
