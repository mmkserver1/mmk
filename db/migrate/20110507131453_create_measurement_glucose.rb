class CreateMeasurementGlucose < ActiveRecord::Migration
  def self.up
    create_table :measurements_glucoses do |t|
      t.references :user
      t.float :value
      t.string :state
      t.timestamps
    end
  end

  def self.down
    drop_table :measurements_glucoses
  end
end
