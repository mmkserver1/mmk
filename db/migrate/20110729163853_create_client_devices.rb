class CreateClientDevices < ActiveRecord::Migration
  def self.up
    create_table :client_devices do |t|
      t.string :manufacturer
      t.string :model
      t.string :imei
      t.string :imsi

      t.timestamps
    end
  end

  def self.down
    drop_table :client_devices
  end
end
