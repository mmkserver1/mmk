class GlucoseThreshold < MeasurementThreshold
  after_initialize :init
  validates_numericality_of :high, :low

  def init
    self.value["high"] ||= 110
    self.value["low"]  ||= 80
  end

  def high
    value["high"].to_i
  end

  def high=(val)
    value["high"] = val
  end

  def low
    value["low"].to_i
  end

  def low=(val)
    value["low"] = val
  end

  def check(measurement)
    measurement.value >= high || measurement.value <= low
  end

end

