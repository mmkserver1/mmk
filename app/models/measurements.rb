module Measurements

  def self.table_name_prefix
    'measurements_'
  end

  module Base
    extend ActiveSupport::Concern

    included do
      belongs_to :user, :class_name => "Patient"
      #after_save :check_notifications
      #after_save :check_thresholds
      has_many :thresholds, :through => :user, :source => "#{self.name.demodulize.downcase}_thresholds"
      belongs_to :client_device, :dependent => :destroy
      belongs_to :medical_device, :dependent => :destroy
      has_one :location, :as => :target, :dependent => :destroy
      #validates :measured_at, :presence => true

      before_save :set_measured_at

      attr_accessible :created_at, :measured_at
      attr_writer :created_at

      def created_at=(val)
        self[:measured_at] = val.to_datetime rescue nil
      end

      def current_thresholds(doctor, patient)
        if doctor && patient
          doctor.send("#{self.class.name.downcase.split("::")[1]}_thresholds").by_patient(patient).where("created_at <= ?", measured_at).order("created_at DESC").first
        else
          nil
        end
      end

      def set_measured_at
        self[:measured_at] = Time.now if self[:measured_at].nil?
      end
    end

    module InstanceMethods
      def check_notifications
        return unless user.doctors
        user.doctors.each do |doctor|
          user.notifications.create(:doctor_id => doctor.id,
                                    :level => "notice",
                                    :measurement => self )
        end
      end
      def check_thresholds
        thresholds.each do |th|
          if th.check(self)
            user.notifications.create(:doctor_id => th.doctor_id,
                                      :level => "warn",
                                      :threshold => th,
                                      :measurement => self )
          end
        end
      end
    end
  end
end
