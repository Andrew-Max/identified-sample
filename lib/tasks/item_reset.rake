namespace :item do
  desc "resets all items to sellable and destroy clearance batches"
  task :reset => :environment do
    Item.all.each { |item| item.update_attribute(:status, "sellable") }
    ClearanceBatch.destroy_all
  end
end
