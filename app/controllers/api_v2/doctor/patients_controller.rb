class ApiV2::Doctor::PatientsController < ApiV2::Doctor::BaseController
  def index
    respond_with @patients = current_doctor.patients
  end
end
