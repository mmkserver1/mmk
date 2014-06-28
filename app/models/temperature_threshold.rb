class TemperatureThreshold < MeasurementThreshold
  after_initialize :init
  validates_numericality_of :high, :low

  def init
    self.value["high"] ||= 37.0
    self.value["low"]  ||= 36.0
  end

  def high
    value["high"].to_f
  end

  def high=(val)
    value["high"] =  val
  end

  def low
    value["low"].to_f
  end

  def low=(val)
    value["low"] = val
  end

  def check(measurement)
    measurement.value >= high || measurement.value <= low
  end

end

