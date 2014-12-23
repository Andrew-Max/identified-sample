namespace :item do
  desc "resets all items to sellable"
  task :reset => :environment do
    Item.all.each { |item| item.update_attribute(:status, "sellable") }
  end
end
