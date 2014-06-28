class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :token_authenticatable, :encryptable, :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable, :recoverable, :rememberable, :trackable, :validatable

  GENDERS = %w(female male)

  # Setup accessible (or protected) attributes for your model
  attr_accessible :email, :password, :password_confirmation,
    :remember_me, :type, :first_name , :middle_name, :last_name, :gender, :birthday, :id, :phone

  has_many :cardiograms, :class_name => "Measurements::Cardiogram"
  has_many :temperatures, :class_name => "Measurements::Temperature"
  has_many :bloodpressures, :class_name => "Measurements::Bloodpressure"
  has_many :glucoses, :class_name => "Measurements::Glucose"
  has_many :oxygens, :class_name => "Measurements::Oxygen"
  has_many :weights, :class_name => "Measurements::Weight"

  validates :gender, :inclusion => GENDERS

  attr_reader :full_name, :display_name

  def password_required?
    new_record? ? true : password.present? || password_confirmation.present?
  end

  def is_doctor?
    false
  end

  def is_patient?
    false
  end

  def gender
    @gender ||= GENDERS[self[:gender].to_i]
  end

  def gender=(value)
    if GENDERS.include?(value)
      self[:gender] = value == "female" ? 0 : 1
    end
  end

  def full_name
    "#{last_name} #{first_name} #{middle_name}"
  end

  def display_name
    (full_name.lstrip.empty?) ? email : full_name
  end

  def to_s
    display_name
  end
end

