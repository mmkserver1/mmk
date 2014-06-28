class RenameTables < ActiveRecord::Migration
  def change
    rename_table :measurements_weighers, :measurements_weights
    rename_table :measurements_oximeters, :measurements_oxygens
  end
end
