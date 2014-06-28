class Measurements::Temperature < ActiveRecord::Base
  include Measurements::Base

  UNITS = %w(C F)

  attr_accessible :value, :units

  after_initialize :init

  validates :value, :numericality => true
  validates :units, :inclusion => UNITS, :allow_nil => true

  def value_in(convert_to = :F)
    if units.to_s == convert_to.to_s
      value
    else
      send "#{units}_to_#{convert_to}", value
    end
  end

  def to_s
    "#{value}#{units} "
  end

  private

  def init
    self.units ||= UNITS.first
  end

  def C_to_F(val)
    val * 9 / 5 + 32
  end

  def F_to_C(val)
    (val - 32) * 5 / 9
  end
end
