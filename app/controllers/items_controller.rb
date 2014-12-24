class ItemsController < ApplicationController
  def index
    if params[:by_batch]
      @batches = ClearanceBatch.all
      @batchless_items = Item.where(clearance_batch_id: nil)
      return render :batch_index
    else
      @items = Item.all.order(:status)
    end
  end
end