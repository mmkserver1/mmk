class CreateMeasurementThresholds < ActiveRecord::Migration
  def self.up
    create_table :measurement_thresholds do |t|
      t.string :type
      t.text :value
      t.references :patient
      t.references :doctor

      t.timestamps
    end
  end

  def self.down
    drop_table :measurement_thresholds
  end
end
