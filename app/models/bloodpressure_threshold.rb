class BloodpressureThreshold < MeasurementThreshold
  after_initialize :init
  validates_numericality_of :high_sys, :high_dia, :high_pulse, :low_sys, :low_dia, :low_pulse

  def init
    self.value["high_sys"]   ||= 140
    self.value["high_dia"]   ||= 100
    self.value["high_pulse"] ||= 120
    self.value["low_sys"]    ||= 100
    self.value["low_dia"]    ||= 60
    self.value["low_pulse"]  ||= 50
  end

  # Systolic
  def high_sys
    value["high_sys"].to_i
  end

  def high_sys=(val)
    value["high_sys"] = val
  end

  def low_sys
    value["low_sys"].to_i
  end

  def low_sys=(val)
    value["low_sys"] = val
  end

  # Diastolic
  def high_dia
    value["high_dia"].to_i
  end

  def high_dia=(val)
    value["high_dia"] = val
  end

  def low_dia
    value["low_dia"].to_i
  end

  def low_dia=(val)
    value["low_dia"] = val
  end

  # Pulse
  def high_pulse
    value["high_pulse"].to_i
  end

  def high_pulse=(val)
    value["high_pulse"] = val
  end

  def low_pulse
    value["low_pulse"].to_i
  end

  def low_pulse=(val)
    value["low_pulse"] = val
  end
end
