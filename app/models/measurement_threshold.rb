class MeasurementThreshold < ActiveRecord::Base
  belongs_to :patient
  belongs_to :doctor
  before_save :convert_value

  default_scope :order => "created_at ASC"

  scope :by_patient, lambda { |patient| where(:patient_id => patient) }

  def check(measurement)
    false
  end

  def value
    @value ||= self[:value] ? JSON::parse(self[:value]) : {}
  end

  private

  def convert_value
    self[:value] = value.to_json
  end

end
