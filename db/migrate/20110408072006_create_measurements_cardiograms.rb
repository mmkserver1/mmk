class CreateMeasurementsCardiograms < ActiveRecord::Migration
  def self.up
    create_table :measurements_cardiograms do |t|
      t.string :filename, :limit => 15
      t.integer :hpc_mode_length, :limit => 2
      t.integer :qrs_duration, :limit => 2
      t.integer :heart_rate, :limit => 2
      t.integer :rhythm_result, :limit => 1
      t.integer :storage_data_type, :limit => 1
      t.binary :rest_unparsed
      t.text :cardiogram

      t.references :user
      t.timestamps
    end
  end

  def self.down
    drop_table :measurements_cardiograms
  end
end
