class CreateMeasurementsWeighers < ActiveRecord::Migration
  def change
    create_table :measurements_weighers do |t|
      t.integer :user_id
      t.float :value
      t.string :unit
      t.datetime :measured_at

      t.integer  :client_device_id, :default => 0
      t.integer  :medical_device_id, :default => 0

      t.timestamps
    end
  end
end
