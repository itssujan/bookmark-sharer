require 'rails_helper'

RSpec.describe User, type: :model do

    subject { described_class.new(first_name: Faker::Name.first_name, last_name: Faker::Name.last_name, email: "john@doe.com") }

    describe "#validations" do
      it "is valid with valid attributes" do
        expect(subject).to be_valid
      end

      it "is not valid without a first_name" do
        subject.first_name = nil
        expect(subject).to_not be_valid
      end

      it "is not valid without an email" do
        subject.email = nil
        expect(subject).to_not be_valid
      end

      it "should validate the email format" do
        subject.email = "foo"
        expect(subject).to_not be_valid
      end

      context "when email is not unique" do
          it "is not valid" do
            user1 = User.new(first_name: Faker::Name.first_name, last_name: Faker::Name.last_name, email: "john@doe.com")
            user1.save

            user2 = User.new(first_name: Faker::Name.first_name, last_name: Faker::Name.last_name, email: "john@doe.com")
            user2.save

            expect(user2.errors[:email]).to eq(["has already been taken"])
          end
      end

      context "when email is unique" do
          before { described_class.new(first_name: Faker::Name.first_name, last_name: Faker::Name.last_name, email: "jane@doe.com") }
          it { expect(subject).to be_valid }
      end
    end
end
