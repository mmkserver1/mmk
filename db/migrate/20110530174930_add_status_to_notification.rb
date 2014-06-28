class AddStatusToNotification < ActiveRecord::Migration
  def self.up
    add_column :notifications, :status, :integer, :default => 0
  end

  def self.down
    remove_column :notifications, :status
  end
end
