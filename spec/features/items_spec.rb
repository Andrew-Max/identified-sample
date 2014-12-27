require "rails_helper"

describe "items index", type: :feature do

  it "has the correct header copy" do
    visit "/items"
    expect(page).to have_content("Stitch Fix Clearance Tool")
  end

  describe "non-batch items index" do
    let!(:items) { 5.times.map { FactoryGirl.create(:item) } }

    it "defaults to an index of all items in a single table" do
      visit "/items"
        expect(page).to have_selector('table', count: 1)
    end

    it "contains a single statistics header" do
      visit "/items"
      expect(page).to have_selector('thead.statistics', count: 1)
    end

    it "contains one row for each item" do
      visit "/items"
      expect(page).to have_selector('tr.item', count: 5)
    end
  end

  describe "batched items index" do
    let(:batches) { 2.times.map { FactoryGirl.create(:clearance_batch) } }
    let!(:batch_one_items) { 2.times.map { FactoryGirl.create(:item, clearance_batch: batches[0]) } }
    let!(:batch_two_items) { 2.times.map { FactoryGirl.create(:item, clearance_batch: batches[1]) } }
    let!(:batchless_items) { 2.times.map { FactoryGirl.create(:item, clearance_batch: nil) } }

    it "has one table for each batch which contains statistics" do
      visit("/items?by_batch=true")
      expect(page).to have_selector('table.clearance-batch', count: 2)
      expect(page).to have_selector('table.clearance-batch .statistics', count: 2)
    end

    it "has one table for each batch which contains statistics" do
      visit("/items?by_batch=true")
      expect(page).to have_selector('table.items-index', count: 1)
      expect(page).to have_selector('table.items-index .statistics', count: 1)
    end
  end
end
