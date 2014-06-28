class DoctorPatient < ActiveRecord::Base
  belongs_to :doctor, :class_name => "Doctor"
  belongs_to :patient, :class_name => "Patient"
end
