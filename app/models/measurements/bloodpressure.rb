# coding: utf-8
class Measurements::Bloodpressure < ActiveRecord::Base
  include Measurements::Base

  attr_accessible :max, :min, :pulse

  validates :max, :inclusion => 0..999
  validates :min, :inclusion => 0..999
  validates :pulse, :inclusion => 0..999

  def to_s
    dt = created_at.strftime(" %d/%m %k:%M:%S")
    "#{dt} | #{max}/#{min} ЧСС #{pulse}"
  end
end
