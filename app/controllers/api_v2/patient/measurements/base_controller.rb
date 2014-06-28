class ApiV2::Patient::Measurements::BaseController < ApiV2::Patient::BaseController
  def index
    from = params[:from].to_datetime rescue nil
    to = params[:to].to_datetime rescue nil
    count = params[:count].to_i
    offset = params[:offset].to_i

    @measurements = current_patient.send(controller_name).order("measured_at DESC")
    @measurements = @measurements.from_time(from) if from
    @measurements = @measurements.to_time(to) if to
    @measurements = @measurements.limit(count) if count > 0
    @measurements = @measurements.offset(offset) if offset > 0

    respond_with @measurements
  end

  def create
    @measurement = current_patient.send(controller_name).new(params[:measurement])
    @measurement.client_device = ClientDevice.find_or_initialize_by_imei_and_imsi_and_manufacturer_and_model(params[:client_device])
    @measurement.medical_device = MedicalDevice.find_or_initialize_by_name_and_address(params[:medical_device])
    @measurement.build_location(params[:location])

    if @measurement.save
      respond_with @measurement, only: :id, status: :ok
    else
      respond_with @measurement, status: :unprocessable_entity
    end
  end
end
