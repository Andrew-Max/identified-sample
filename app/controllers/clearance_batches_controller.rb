class ClearanceBatchesController < ApplicationController
  def index
    @accept_loose = params[:loose]
    @clearance_batches  = ClearanceBatch.all
  end

  def show
    @batch = ClearanceBatch.find(params[:id])
  end

  def create
    if params[:csv_batch_file]
      check_valid_file
      clearancing_status = ClearancingService.new.process_file(params[:csv_batch_file].tempfile)
    else
      clearancing_status = ClearancingService.new.process_loose_ids(params[:ids])
    end

    set_alert_messages(clearancing_status)
    redirect_to action: :index
  end

  private

  def set_alert_messages(clearancing_status)
    clearance_batch = clearancing_status.clearance_batch
    alert_messages = []
    if clearance_batch.persisted?
      flash[:notice]  = "#{clearance_batch.items.count} items clearanced in batch #{clearance_batch.id}"
    else
      alert_messages << "No new clearance batch was added"
    end

    if clearancing_status.errors.any?
      alert_messages << "#{clearancing_status.errors.count} item ids raised errors and were not clearanced"
      clearancing_status.errors.each {|error| alert_messages << error }
    end
    flash[:alert] = alert_messages.join("<br/>") if alert_messages.any?
  end

  def check_valid_file
    if params[:csv_batch_file] == nil
      message = "You did not chose a file to upload"
    elsif !(params[:csv_batch_file].original_filename.split(".").last == "csv")
      message = "The file you uploaded was not a csv"
    end

    if message
      flash[:alert] = message
      return redirect_to action: :index
    end
  end
end
