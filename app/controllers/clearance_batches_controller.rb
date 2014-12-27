require 'csv'

class ClearanceBatchesController < ApplicationController
  before_action :check_valid_inputs, only: :create
  before_action :set_batch_ids, only: :create

  def index
    @accept_loose = params[:loose] == "true"
    @clearance_batches = ClearanceBatch.all
  end

  def show
    @batch = ClearanceBatch.find(params[:id])
  end

  def create
    clearancing_status = ClearancingService.new.clearance_batch(@batch)
    set_alert_messages(clearancing_status)
    action = { action: :index }
    action[:loose] = true if params[:loose]
    redirect_to action
  end

  private

  def check_valid_inputs
    if params[:csv_file]
      check_valid_file
    elsif params[:loose]
      check_valid_input_string
    end
  end

  def check_valid_file
    if params[:csv_batch_file] == nil
      message = "You did not chose a file to upload"
    elsif !(params[:csv_batch_file].original_filename.split(".").last == "csv")
      # would want to check mime type on a production application
      message = "The file you uploaded was not a CSV file"
    end

    if message
      flash[:alert] = message
      redirect_to action: :index
    end
  end

  def check_valid_input_string
    if params[:ids] == ""
      message = "You did not input anything"
    elsif params[:ids] =~ /[^,\d\s]+/
      message = "You submitted illegal characters. Please submit only comma seperated numbers"
    end

    if message
      flash[:alert] = message
      redirect_to action: :index, loose: true
    end
  end

  def set_batch_ids
    if params[:csv_batch_file]
      @batch = []
      CSV.foreach(params[:csv_batch_file].tempfile, headers: false) do |row|
        @batch << row[0].to_i
      end
    elsif params[:ids]
      @batch = params[:ids].gsub(" ", "").split(",").map!(&:to_i)
    end
  end

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
end
