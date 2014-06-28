class CreateMeasurementsBloodpressure < ActiveRecord::Migration
  def self.up
    create_table :measurements_bloodpressures do |t|
      t.integer :max, :limit => 2
      t.integer :min, :limit => 2
      t.integer :pulse, :limit => 2

      t.references :user
      t.timestamps
    end
  end

  def self.down
    drop_table :measurements_bloodpressures
  end
end
