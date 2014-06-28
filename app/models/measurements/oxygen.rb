class Measurements::Oxygen < ActiveRecord::Base
  include Measurements::Base
  serialize :waveform

  attr_accessible :spo2, :pulse, :waveform

  validates :spo2, :inclusion => 0..100
  validates :pulse, :inclusion => 0..999

  def waveform=(val)
    self[:waveform] = val.tr("[]", "").split(",").map(&:to_i)
  end
end
