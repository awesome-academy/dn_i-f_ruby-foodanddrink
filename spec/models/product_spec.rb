require "rails_helper"

RSpec.describe Product, type: :model do
  describe "association" do
    it "belong to category" do
      should belong_to(:category)
    end

    it "has many order details" do
      should have_many(:order_details).dependent(:destroy)
    end

    it "has many orders through order details" do
      should have_many(:orders).through(:order_details)
    end

    it "nested attribute category" do
      should accept_nested_attributes_for(:category)
    end
  end

  describe "Scope" do
    let!(:category_1){FactoryBot.create :category}
    let!(:product_1){FactoryBot.create :product, category_id: category_1.id}
    let!(:product_2){FactoryBot.create :product, name: "Nước ép"}
    let!(:product_3){FactoryBot.create :product}

    context "with scope recent"  do
      it "return list product sort create_day DESC" do
        expect(Product.recent).to eq([product_3, product_2, product_1])
      end
    end

    context "with scope find_name"  do
      it "search product by name " do
        expect(Product.find_name("Nước")).to eq [product_2]
      end

      it "when name not found " do
        expect(Product.find_name("kakakakka")).to eq []
      end
    end

    context "with scope list_product" do
      it "return product with id = 3" do
        expect(Product.list_product(product_3.id)).to eq [product_3]
      end
      it " when id not found" do
        expect(Product.list_product(-1)).to eq []
      end
    end

    context "with scope search_category" do
      it "return product with category_id" do
        expect(Product.search_category(category_1.id)).to eq [product_1]
      end

      it "when category_id not found" do
        expect(Product.search_category(-1)).to eq []
      end
    end
  end

  describe "has one image" do
    context "with a valid image" do
      it { should have_one(:image_attachment) }
    end
  end

  describe "Delegate category" do
    it { should delegate_method(:name).to(:category).with_prefix }
  end

  describe "Validations" do
    context "with field name" do
      it { should validate_presence_of(:name) }

      it { should validate_length_of(:name).is_at_least(6) }

      it { should validate_length_of(:name).is_at_most(100) }
    end

    context "with field price" do
      it { should validate_presence_of(:price) }

      it { should validate_numericality_of(:price) }

      it { should allow_value(0).for(:price) }

      it { should_not allow_value(-1).for(:price) }
    end

    context "with field description" do
      it { should validate_presence_of(:description) }

      it { should validate_length_of(:description).is_at_least(6) }

      it { should validate_length_of(:description).is_at_most(300) }
    end

    context "with field quantity" do
      it { should validate_presence_of(:quantity) }

      it { should validate_numericality_of(:quantity).only_integer }

      it { should allow_value(0).for(:quantity) }

      it { should_not allow_value(-1).for(:quantity) }
    end
  end
end
