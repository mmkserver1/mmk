# coding: utf-8

class Doctor < User

  has_many :doctor_patients, :foreign_key => :doctor_id , :class_name => "DoctorPatient"
  has_many :patients, :through => :doctor_patients

  has_many :measurement_thresholds
  has_many :bloodpressure_thresholds
  has_many :temperature_thresholds
  has_many :glucose_thresholds
  has_many :cardiogram_thresholds
  has_many :notifications

  def is_doctor?
    true
  end

end

