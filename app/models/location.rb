class Location < ActiveRecord::Base
  belongs_to :target, :polymorphic => true

  attr_accessible :latitude, :longitude, :altitude
end
