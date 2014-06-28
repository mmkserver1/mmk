class CreateMeasurementsOximeters < ActiveRecord::Migration
  def change
    create_table :measurements_oximeters do |t|
      t.integer :user_id
      t.integer :spo2
      t.integer :pulse
      t.text :waveform # Blood Volume Fluctuations
      t.datetime :measured_at

      t.integer  :client_device_id, :default => 0
      t.integer  :medical_device_id, :default => 0

      t.timestamps
    end
  end
end
