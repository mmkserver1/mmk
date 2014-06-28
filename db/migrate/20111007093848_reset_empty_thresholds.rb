class ResetEmptyThresholds < ActiveRecord::Migration
  def up
    default = BloodpressureThreshold.new
    BloodpressureThreshold.all.each do |i|
      attrs = {}
      [:high_sys, :high_dia, :high_pulse, :low_sys, :low_dia, :low_pulse].each do |attr|
        attrs.merge(attr => default.send(attr)) if i.send(attr).zero?
      end
      i.update_attributes(attrs)
    end

    default = GlucoseThreshold.new
    GlucoseThreshold.all.each do |i|
      attrs = {}
      [:high, :low].each do |attr|
        attrs.merge(attr => default.send(attr)) if i.send(attr).zero?
      end
      i.update_attributes(attrs)
    end

    default = TemperatureThreshold.new
    TemperatureThreshold.all.each do |i|
      attrs = {}
      [:high, :low].each do |attr|
        attrs.merge(attr => default.send(attr)) if i.send(attr).zero?
      end
      i.update_attributes(attrs)
    end
  end

  def down
  end
end
