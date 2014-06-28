class CreateSoftwarePackages < ActiveRecord::Migration
  def self.up
    create_table :software_packages do |t|
      t.string :version
      t.string :build
      t.string :filename

      t.timestamps
    end
  end

  def self.down
    drop_table :software_packages
  end
end
