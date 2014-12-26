require 'rails_helper'

describe Item do
  describe "#clearance!" do

    let(:wholesale_price) { 100 }
    let(:style) { FactoryGirl.create(:style, wholesale_price: wholesale_price) }
    let(:item) { FactoryGirl.create(:item, style: style) }
    before do
      item.clearance!
      item.reload
    end

    it "should mark the item status as clearanced" do
      expect(item.status).to eq("clearanced")
    end

    it "should set the price_sold as 75% of the wholesale_price" do
      expect(item.price_sold).to eq(BigDecimal.new(wholesale_price) * BigDecimal.new("0.75"))
    end
  end

  describe "#acceptably_clearance_priced?" do
    let(:item) { FactoryGirl.create(:item, style: style) }

    describe "for items with style which allows a 5 dollar minimum clearance price" do
      let(:style) { FactoryGirl.create(:style, type: "pants", wholesale_price: wholesale_price) }

      describe "with an acceptable price" do
        let(:wholesale_price) { 7 }

        it "returns true" do
          expect(item.acceptably_clearance_priced?).to be_truthy
        end
      end

      describe "with an unacceptable price" do
        let(:wholesale_price) { 6 }

        it "returns false" do
          expect(item.acceptably_clearance_priced?).to be_falsey
        end
      end
    end

    describe "for items with style which allows a 2 dollar minimum clearance price" do
      let(:style) { FactoryGirl.create(:style, type: "scarf", wholesale_price: wholesale_price) }

      describe "with an acceptable price" do
        let(:wholesale_price) { 3 }

        it "returns true" do
          expect(item.acceptably_clearance_priced?).to be_truthy
        end
      end

      describe "with an unacceptable price" do
        let(:wholesale_price) { 2 }

        it "returns false" do
          expect(item.acceptably_clearance_priced?).to be_falsey
        end
      end
    end
  end
end
