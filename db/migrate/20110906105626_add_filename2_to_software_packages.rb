class AddFilename2ToSoftwarePackages < ActiveRecord::Migration
  def self.up
    add_column :software_packages, :filename2, :string
  end

  def self.down
    remove_column :software_packages, :filename2
  end
end
