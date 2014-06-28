class CreateMeasurementsTemperatures < ActiveRecord::Migration
  def self.up
    create_table :measurements_temperatures do |t|
      t.references :user
      t.float :value
      t.string :units, :limit => 1
      t.timestamps
    end
  end

  def self.down
    drop_table :measurements_temperatures
  end
end
