class CreateLocations < ActiveRecord::Migration
  def change
    create_table :locations do |t|
      t.integer :target_id
      t.integer :target_type

      t.float :latitude
      t.float :longitude
      t.float :altitude

      t.timestamps
    end
  end
end
