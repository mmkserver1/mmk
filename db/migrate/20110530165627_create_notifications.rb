class CreateNotifications < ActiveRecord::Migration
  def self.up
    create_table :notifications do |t|
      t.text :desc
      t.string :level
      t.references :patient
      t.references :doctor

      t.timestamps
    end
  end

  def self.down
    drop_table :notifications
  end
end
