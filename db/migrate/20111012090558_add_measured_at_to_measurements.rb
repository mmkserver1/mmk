class AddMeasuredAtToMeasurements < ActiveRecord::Migration
  def change
    [:measurements_bloodpressures, :measurements_cardiograms, :measurements_glucoses, :measurements_temperatures].each do |i|
      add_column i, :measured_at, :datetime
    end

    [Measurements::Bloodpressure,
     Measurements::Cardiogram,
     Measurements::Glucose,
     Measurements::Temperature,
     Measurements::Oxygen,
     Measurements::Weight].each do |i|
      i.reset_column_information
      i.all.each do |j|
        j.measured_at = j.created_at || j.updated_at unless j.measured_at
        j.save(:validate => false)
      end
    end
  end
end
