class AddPlatformToSoftwarePackages < ActiveRecord::Migration
  def self.up
    add_column :software_packages, :platform, :string
  end

  def self.down
    remove_column :software_packages, :platform
  end
end
