class AccountType < ActiveRecord::Base
  has_many :accounts
  has_many :patients, :through => :accounts

  validates_uniqueness_of :name

  before_save lambda { self.name.downcase! }
end
