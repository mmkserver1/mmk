class CreateMedicalDeviceLists < ActiveRecord::Migration
  def change
    create_table :medical_device_lists do |t|
      t.string :device_type
      t.string :address

      t.timestamps
    end
  end
end
