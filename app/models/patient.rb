class Patient < User
  scope :by_name, lambda{ order('last_name, first_name') }
  scope :by_last_measurement, lambda{ joins("LEFT JOIN
    (
      SELECT user_id, measured_at from measurements_cardiograms
      UNION
      SELECT user_id, measured_at from measurements_cardiograms
      UNION
      SELECT user_id, measured_at from measurements_glucoses
      UNION
      SELECT user_id, measured_at from measurements_oxygens
      UNION
      SELECT user_id, measured_at from measurements_temperatures
      UNION
      SELECT user_id, measured_at from measurements_weights
    ) measurements
    ON measurements.user_id=users.id
    ").group("users.id").order("max(measurements.measured_at)  DESC")  }

  has_many :patient_doctors, :foreign_key => :patient_id , :class_name => "DoctorPatient", :dependent => :destroy
  has_many :doctors, :through => :patient_doctors
  has_many :measurement_thresholds, :dependent => :destroy
  has_many :cardiogram_thresholds, :dependent => :destroy
  has_many :bloodpressure_thresholds, :dependent => :destroy
  has_many :glucose_thresholds, :dependent => :destroy
  has_many :temperature_thresholds, :dependent => :destroy
  has_many :notifications
  has_many :accounts, :dependent => :destroy
  attr_reader :measurements_alert

  def is_patient?
    true
  end

  def set_measurements_alert(doctor_id)
    @measurements_alert = :none
    @measurements_alert = :more if check_status(:more, doctor_id)
    @measurements_alert = :month if check_status(:month, doctor_id)
    @measurements_alert = :week if check_status(:week, doctor_id)
    @measurements_alert = :day if check_status(:day,doctor_id)
  end

  def check_status (date_type = :day, doctor_id)

    start_date = case date_type
    when :day
      Time.now - 1.day
    when :week
      Time.now - 1.week
    when :month
      Time.now - 1.month
    when :more
      Time.now - 100.years
    end

    #rewrite to send with array
    temp_result = check_temperature(doctor_id, start_date)
    gluc_result = check_glucose(doctor_id, start_date)
    blood_result = check_bloodpressure(doctor_id, start_date)

    [temp_result, gluc_result, blood_result].include? true
  end

  def check_temperature(doctor_id, start_date)
    temp = temperatures.where(:measured_at => start_date..Date.tomorrow)
    temp_threshold = temperature_thresholds.where(:doctor_id => doctor_id).first
    temp.map {|t| temp_threshold.try(:check,t) }.include? true
  end

  def check_glucose(doctor_id, start_date)
    gluc = glucoses.where(:measured_at => start_date..Date.tomorrow)
    gluc_threshold = glucose_thresholds.where(:doctor_id => doctor_id).first
    gluc.map {|t| gluc_threshold.try(:check,t)}.include? true
  end

  def check_bloodpressure(doctor_id, start_date)
    blood = bloodpressures.where(:measured_at => start_date..Date.tomorrow)
    blood_threshold = bloodpressure_thresholds.where(:doctor_id => doctor_id).first
    blood.map {|t| blood_threshold.try(:check,t)}.include? true
  end

  def last_measurement_time
    @last_measurement_time ||= [bloodpressures.last,
     cardiograms.last,
     glucoses.last,
     oxygens.last,
     temperatures.last,
     weights.last].compact.map(&:measured_at).compact.sort.last
  end

  def cardiograms_state(doctor)
    if doctor
      state = :none
      state = :some if cardiograms.any?
    else
      state = nil
    end
    state
  end

  def bloodpressures_state(doctor)
    if doctor
      state = :none
      state = :some if bloodpressures.any?
      state = :alert if check_bloodpressure(doctor.id, Time.now - 1.day)
    else
      state = nil
    end
    state
  end

  def glucoses_state(doctor)
    if doctor
      state = :none
      state = :some if glucoses.any?
      state = :alert if check_glucose(doctor.id, Time.now - 1.day)
    else
      state = nil
    end
    state
  end

  def temperatures_state(doctor)
    if doctor
      state = :none
      state = :some if temperatures.any?
      state = :alert if check_temperature(doctor.id, Time.now - 1.day)
    else
      state = nil
    end
    state
  end

end
