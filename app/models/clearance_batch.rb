class ClearanceBatch < ActiveRecord::Base

  has_many :items

  def total_cost
    item_price_list.inject { |sum, x| sum + x }.to_f
  end

  def average_price
    total_cost / item_price_list.size
  end

  private

  def item_price_list
    items.pluck(:price_sold)
  end
end
