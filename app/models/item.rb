class Item < ActiveRecord::Base

  CLEARANCE_PRICE_PERCENTAGE  = BigDecimal.new("0.75")
  HIGH_PRICE_ITEMS = ["pants", "dress"]

  belongs_to :style
  belongs_to :clearance_batch

  scope :sellable, -> { where(status: 'sellable') }

  def clearance!
    update_attributes!(status: 'clearanced',
                       price_sold: clearance_price)
  end

  def acceptably_clearance_priced?
    # can be shorter with price ceiling
    if HIGH_PRICE_ITEMS.include?(style.type.downcase)
      clearance_price >= 5
    else
      clearance_price >= 2
    end
  end

  def clearance_price
    style.wholesale_price * CLEARANCE_PRICE_PERCENTAGE
  end

end
