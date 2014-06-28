class CreateAccounts < ActiveRecord::Migration
  def self.up
    create_table :accounts do |t|
      t.references :patient
      t.string :code
      t.references :account_type

      t.timestamps
    end
  end

  def self.down
    drop_table :accounts
  end
end
