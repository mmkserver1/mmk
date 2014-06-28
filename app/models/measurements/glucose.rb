class Measurements::Glucose < ActiveRecord::Base
  include Measurements::Base

  STATES = %w(unknown before_meals after_meals)

  attr_accessible :value, :state

  after_initialize :init

  validates :value, :numericality => true
  validates :state, :inclusion => STATES, :allow_nil => true

  def to_s
    "#{value} #{I18n.t(state)}"
  end

  private

  def init
    self.state ||= STATES.first
  end

end
