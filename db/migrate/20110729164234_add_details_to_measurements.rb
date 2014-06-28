class AddDetailsToMeasurements < ActiveRecord::Migration
  def self.up
    add_column :measurements_bloodpressures, :client_device_id, :integer, :default => 0
    add_column :measurements_cardiograms, :client_device_id, :integer, :default => 0
    add_column :measurements_temperatures, :client_device_id, :integer, :default => 0
    add_column :measurements_glucoses, :client_device_id, :integer, :default => 0

    add_column :measurements_bloodpressures, :medical_device_id, :integer, :default => 0
    add_column :measurements_cardiograms, :medical_device_id, :integer, :default => 0
    add_column :measurements_temperatures, :medical_device_id, :integer, :default => 0
    add_column :measurements_glucoses, :medical_device_id, :integer, :default => 0
  end

  def self.down
    remove_column :measurements_bloodpressures, :client_device_id
    remove_column :measurements_cardiograms, :client_device_id
    remove_column :measurements_temperatures, :client_device_id
    remove_column :measurements_glucoses, :client_device_id

    remove_column :measurements_bloodpressures, :medical_device_id
    remove_column :measurements_cardiograms, :medical_device_id
    remove_column :measurements_temperatures, :medical_device_id
    remove_column :measurements_glucoses, :medical_device_id
  end
end
