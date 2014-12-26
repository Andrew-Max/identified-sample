require "rails_helper"

describe "clearance_batches index", type: :feature do

  describe "before any actions" do

    it "has the correct header copy" do
      visit "/"
      expect(page).to have_content("Stitch Fix Clearance Tool")
      expect(page).to have_content("Clearance Batches")
    end

    it "defaults to csv input" do
      visit "/"
      expect(page).to have_content("Clearance Batches From a File")
      expect(page).to have_css("input.csv-upload")
    end

    it "can switch to manual id input" do
      visit "/"
      click_link("Switch to Id Input")
      expect(page).to have_content("Clearance Batches By Entering Ids")
      expect(page).to have_css("textarea.id-input")
    end
    # I'm punting on testing the excel download. It should be teseted if it is in production though.

  end

  describe "see previous clearance batches" do
    let!(:clearance_batch_2) { FactoryGirl.create(:clearance_batch) }
    let!(:clearance_batch_1) { FactoryGirl.create(:clearance_batch) }

    it "displays a list of all past clearance batches" do
      visit "/"
      within('table.clearance-batches') do
        expect(page).to have_content("Clearance Batch #{clearance_batch_1.id}")
        expect(page).to have_content("Clearance Batch #{clearance_batch_2.id}")
      end
    end
  end

  describe "add a new clearance batch by file" do

    context "total success" do

      it "should allow a user to upload a new clearance batch successfully" do
        items = 5.times.map{ FactoryGirl.create(:item) }
        file_name = generate_csv_file(items)
        visit_and_upload(page, file_name)

        new_batch = ClearanceBatch.first
        expect(page).to have_content("#{items.count} items clearanced in batch #{new_batch.id}")
        expect(page).not_to have_content("item ids raised errors and were not clearanced")
        within('table.clearance-batches') do
          expect(page).to have_content(/Clearance Batch \d+/)
        end
      end
    end

    context "partial success" do

      it "should allow a user to upload a new clearance batch partially successfully, and report on errors" do
        valid_items   = 3.times.map{ FactoryGirl.create(:item) }
        invalid_items = [[987654], ['no thanks']]
        file_name     = generate_csv_file(valid_items + invalid_items)
        visit_and_upload(page, file_name)

        new_batch = ClearanceBatch.first
        expect(page).to have_content("#{valid_items.count} items clearanced in batch #{new_batch.id}")
        expect(page).to have_content("#{invalid_items.count} item ids raised errors and were not clearanced")
        within('table.clearance-batches') do
          expect(page).to have_content(/Clearance Batch \d+/)
        end
      end
    end

    context "total failure" do

      it "should allow a user to upload a new clearance batch that totally fails to be clearanced" do
        invalid_items = [[987654], ['no thanks']]
        file_name     = generate_csv_file(invalid_items)
        visit_and_upload(page, file_name)

        expect(page).not_to have_content("items clearanced in batch")
        expect(page).to have_content("No new clearance batch was added")
        expect(page).to have_content("#{invalid_items.count} item ids raised errors and were not clearanced")
        within('table.clearance-batches') do
          expect(page).not_to have_content(/Clearance Batch \d+/)
        end
      end
    end

  end
end

def visit_and_upload(page, file_name)
  visit "/"
  within('table.clearance-batches') do
    expect(page).not_to have_content(/Clearance Batch \d+/)
  end
  attach_file("csv_batch_file", file_name)
  click_button "upload batch file"
end
