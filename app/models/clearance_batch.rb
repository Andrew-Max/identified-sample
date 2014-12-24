class ClearanceBatch < ActiveRecord::Base

  has_many :items

  def total_cost
    item_prices.inject { |sum, x| sum + x }.to_f
  end

  def average_price
    total_cost / item_prices.size
  end

  private

  def item_prices
    items.pluck(:price_sold)
  end

end
