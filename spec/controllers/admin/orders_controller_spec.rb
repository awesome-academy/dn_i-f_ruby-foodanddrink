require "rails_helper"
require("pry")
RSpec.describe Admin::OrdersController, type: :controller do
  describe "GET #index" do
    context "when not log in" do
      before do
        get :index, params: {locale: I18n.locale}
      end

      it "redirect to new_user_session_path" do
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
        it "redirect to new_user_session_path" do
          expect(response).to redirect_to root_url
        end
      end

      context "when has permission, sort create_order DESC" do
        let!(:user) {FactoryBot.create :user, role: :admin}
        let!(:order_1) {FactoryBot.create :order}
        let!(:order_2) {FactoryBot.create :order}
        let!(:order_3) {FactoryBot.create :order}
        before do
          sign_in user
          get :index
        end

        it "assigns orders" do
          expect(assigns(:orders)).to eq ([order_3,order_2, order_1])
        end
      end
    end
  end

  describe "when log in and has permission" do
    let(:user) {FactoryBot.create :user, role: :admin}
    before do
      sign_in user
    end

    describe "GET #show" do
      let(:order) {FactoryBot.create :order, user_id: user.id}

      context "when order not found" do
        before do
          get :show, params: {id: -1}
        end

        it "display flash danger" do
          expect(flash[:danger]).to eq I18n.t("orders.no_order")
        end
        it "redirect to admin orders" do
          expect(response).to redirect_to admin_orders_path
        end
      end

      context "when order any" do
        let!(:product) {FactoryBot.create :product}
        let!(:order_detail) {FactoryBot.create :order_detail, order_id: order.id, product_id: product.id}
        before do
          get :show, params: {id: order.id}
          @order_detail = order.order_details.includes(:product)
        end

        it "assigns order" do
          expect(assigns(:order)).to eq order
        end
         it "assigns order_detail" do
          expect(assigns(:order_detail)).to eq @order_detail
        end
        it "renders the template show" do
          expect(response).to render_template :show
        end
      end
    end

    describe "PUT #approve" do
      context "when order status open" do
        let(:order) {FactoryBot.create :order, status: :open}
        before do
          put :approve, params: {id: order.id}
        end

        it "check status after approve" do
          expect(assigns(:order).status).to eq "confirmed"
        end

        it "display flash success" do
          expect(flash[:success]).to eq I18n.t("orders.approve_success")
        end
        it "redirect to admin order" do
          expect(response).to redirect_to admin_orders_path
        end
      end
    end

    describe "PUT #reject" do
      context "when order status confirmed or open" do
        let(:order) {FactoryBot.create :order, status: :confirmed}
        before do
          put :reject, params: {id: order.id}
        end

         it "check status after approve" do
          expect(assigns(:order).status).to eq "disclaim"
        end

        it "display flash success" do
          expect(flash[:success]).to eq I18n.t("orders.reject_success")
        end
        it "redirect to admin order" do
          expect(response).to redirect_to admin_orders_path
        end
      end
    end
  end
end
