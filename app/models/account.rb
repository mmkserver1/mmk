class Account < ActiveRecord::Base
  belongs_to :patient
  belongs_to :account_type
  delegate :name, :to => :account_type

  def to_s
    code
  end
end
