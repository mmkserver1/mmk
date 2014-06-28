class MedicalDeviceList < ActiveRecord::Base
  attr_accessible :address, :device_type

  validates :address, uniqueness: true, presence: true
end
