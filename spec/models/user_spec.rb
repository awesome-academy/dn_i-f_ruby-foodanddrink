require "rails_helper"

RSpec.describe User, type: :model do
  describe "association" do
    it "has many address" do
      should have_many(:addresses).dependent(:destroy)
    end

    it "has many orders" do
      should have_many(:orders).dependent(:destroy)
    end
  end

  describe "enums" do
    it "define role as an enum"do
      should define_enum_for(:role).with_values(
        user: 0,
        admin: 1)
    end
  end

  describe "Validations" do
    subject { FactoryBot.create :user, email: "pkbb@gmail.com" }
    context "with field name" do
      it { should validate_presence_of(:name) }

      it { should validate_length_of(:name).is_at_least(6) }

      it { should validate_length_of(:name).is_at_most(100) }
    end

    context "with field email" do
      it { should validate_presence_of(:email) }

      it { should validate_uniqueness_of(:email).case_insensitive }

      it "when too short is invalid" do
        should_not allow_value("pkaa").for(:email)
      end

      it "when email valid" do
        should allow_value("pkbb@gmail.com").for(:email)
      end
    end

    context "with field password" do
      it { should validate_presence_of(:password).allow_nil }

      it { should validate_length_of(:password).is_at_least(6) }

      it { should validate_confirmation_of(:password) }
    end
  end
end
