class Item < ActiveRecord::Base

  CLEARANCE_PRICE_PERCENTAGE  = BigDecimal.new("0.75")
  HIGH_PRICE_ITEMS = ["pants", "dress"]

  belongs_to :style
  belongs_to :clearance_batch

  scope :sellable, -> { where(status: 'sellable') }
  scope :sweaters, -> { where(["style_id=? OR style_id=?",1,2]) }
  scope :tops, -> { where(style_id: 3) }
  scope :dresses, -> { where(["style_id=? OR style_id=?",4,5]) }
  scope :scarves, -> { where(style_id: 7) }
  scope :pants, -> { where(["style_id=? OR style_id=?",6,8]) }

  def clearance!
    update_attributes!(status: 'clearanced',
                       price_sold: clearance_price,
                       sold_at: DateTime.now)
  end

  def acceptably_clearance_priced?
    acceptable_price = HIGH_PRICE_ITEMS.include?(style.type.downcase) ? 5 : 2
    clearance_price >= acceptable_price
  end

  def clearance_price
    style.wholesale_price * CLEARANCE_PRICE_PERCENTAGE
  end

end
