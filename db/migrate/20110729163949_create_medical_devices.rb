class CreateMedicalDevices < ActiveRecord::Migration
  def self.up
    create_table :medical_devices do |t|
      t.string :name
      t.string :address

      t.timestamps
    end
  end

  def self.down
    drop_table :medical_devices
  end
end
