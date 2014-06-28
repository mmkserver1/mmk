class Measurements::Weight < ActiveRecord::Base
  include Measurements::Base

  UNITS = %w(kg lb)

  attr_accessible :value, :unit

  after_initialize :init

  validates :value, :numericality => true
  validates :unit, :inclusion => UNITS, :allow_nil => true

  private

  def init
    self.unit ||= UNITS.first
  end
end
