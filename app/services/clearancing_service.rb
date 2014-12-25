require 'ostruct'
class ClearancingService

  def clearance_batch(batch)
    # note clean interface
    clearancing_status = create_clearancing_status
    batch.each { |potential_item_id| add_to_clearancing_status(clearancing_status, potential_item_id) }
    clearance_items!(clearancing_status)
  end

private

  def clearance_items!(clearancing_status)
    if clearancing_status.clearancable_items.any?
      clearancing_status.clearance_batch.save!
      clearancing_status.clearancable_items.each do |item|
        item.clearance!
        clearancing_status.clearance_batch.items << item
      end
    end
    clearancing_status
  end

  def add_to_clearancing_status(clearancing_status, potential_item_id)
    # note this being large cuz single query
    errors = clearancing_status.errors
    if potential_item_id.blank? || potential_item_id == 0 || !potential_item_id.is_a?(Integer)
      return errors << "Item # #{potential_item_id} is not valid"
    end

    item = Item.where(id: potential_item_id).first

    if item.blank?
      return errors << "Item # #{potential_item_id} could not be found"
    elsif !(item.status == "sellable")
      return errors << "Item # #{potential_item_id} could not be clearanced"
    elsif !(item.acceptably_clearance_priced?)
      return errors << "Item # #{potential_item_id} does not meet the minimum clearance pricing criteria"
    end

    clearancing_status.clearancable_items << item
  end

  def create_clearancing_status
    OpenStruct.new(
      clearance_batch: ClearanceBatch.new,
      clearancable_items: [],
      errors: [])
  end
end
