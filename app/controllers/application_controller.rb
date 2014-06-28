class ApplicationController < ActionController::Base
  protect_from_forgery

  helper_method :current_doctor, :current_user_or_patient

  private

  def must_be_doctor!
     redirect_to :root unless Doctor.find_by_id(current_user)
  end

  def current_doctor
    Doctor.find_by_id(current_user.id)
  end

  def current_user_or_patient
    if current_doctor && (patient = current_doctor.patients.find_by_id params[:patient_id])
      patient
    else
      current_user
    end
  end
end
