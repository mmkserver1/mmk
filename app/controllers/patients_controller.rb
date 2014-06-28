class PatientsController < ApplicationController
  before_filter :authenticate_user!
  before_filter  :must_be_doctor!, :except => [:index]

  def add_account
    account_type = params[:account_type]
    account_code = params[:account_code]
    @patient = current_doctor.patients.find_by_id params[:patient_id]
    if @patient && account_code && account_type
      account_type = AccountType.find_or_create_by_name(account_type)
      account_type.accounts.create(:code => account_code, :patient_id => @patient.id )
      render :xml => @patient
    else
      render :xml => @patient, :status => :unprocessable_entity
    end
  end


  def register
    first_name = params[:first_name]
    middle_name = params[:middle_name]
    last_name = params[:last_name]
    birthday = params[:birthday]
    email = params[:email]
    phone = params[:phone]

    @patient = Patient.new
    @patient.first_name = first_name
    @patient.middle_name = middle_name
    @patient.last_name = last_name
    @patient.birthday = birthday
    @patient.email = email
    @patient.phone = phone
    generated_password = Patient.send(:generate_token, 'encrypted_password')
    generated_password.slice!(13 - rand(5)..generated_password.length)
    @patient.password = generated_password
    @patient.password_confirmation = generated_password

    if @patient.save
      current_doctor.patients<<@patient
      render :xml => @patient, :status => :created, :location => @patient
    else
      render :xml => @patient.errors, :status => :unprocessable_entity
    end

  end

  def unlist
    patient = current_doctor.patients.find params[:id]
    current_doctor.patients.delete(patient)
    redirect_to patients_path
  end

  def enroll
    patient = Patient.find(params[:id])
    current_doctor.patients << patient
    redirect_to patients_path
  end

  def account
    account_code = params[:account_code]
    account_type = AccountType.find_by_name params[:account_type].downcase
    account = Account.where(:code => account_code, :account_type_id => account_type).first

    @patients = account.try(:patient)
    @patients = account_type.patients.includes(:accounts) if account_type && !account_code
    @patients ||= []

    respond_to do |format|
      format.xml  { render :xml => @patients.to_xml(:include => {:accounts => { :include => :account_type}} )  }
    end
  end

  # GET /patients.xml
  def index
    sort=params[:sort]

    if current_doctor
      if sort=="name"
        @patients = current_doctor.patients.by_name
      else
        @patients = current_doctor.patients.by_last_measurement
      end
    else
      @patients=[*current_user_or_patient]
    end

    @patients.each do |p|
      p.set_measurements_alert(current_doctor.id) if current_doctor
    end

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @patients.map{ |i| {:id => i.id, :email => i.email, :last_name => i.last_name,
        :first_name => i.first_name, :middle_name => i.middle_name, :birthday => i.birthday, :phone => i.phone,
        :measurements_alert => i.measurements_alert,
        :last_measurement_time => i.last_measurement_time,
        :bloodpressures_state => i.bloodpressures_state(current_doctor),
        :cardiograms_state => i.cardiograms_state(current_doctor),
        :glucoses_state => i.glucoses_state(current_doctor),
        :temperatures_state => i.temperatures_state(current_doctor)
      } }.to_xml(:root => "patients") }
    end
  end

  # GET /patients/1
  # GET /patients/1.xml
  def show
    @patient = current_doctor.patients.find(params[:id])
    @temperature_thresholds = current_doctor.temperature_thresholds.by_patient(@patient)
    @glucose_thresholds = current_doctor.glucose_thresholds.by_patient(@patient)
    @bloodpressure_thresholds = current_doctor.bloodpressure_thresholds.by_patient(@patient)
    @cardiogram_thresholds = current_doctor.cardiogram_thresholds.by_patient(@patient)

    respond_to do |format|
      format.html
      format.xml  { render :xml => @patient }
    end
  end

  # GET /patients/new
  # GET /patients/new.xml
  def new
    @patients= Patient.by_name - current_doctor.patients.all

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @patients }
    end
  end

  # GET /patients/1/edit
  def edit
    @patient = Patient.find(params[:id])
  end

  # POST /patients
  # POST /patients.xml
  def create
    @patient = Patient.new(params[:patient])

    respond_to do |format|
      if @patient.save
        format.html { redirect_to(@patient, :notice => I18n.t("notifications.patients.create_success")) }
        format.xml  { render :xml => @patient, :status => :created, :location => @patient }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @patient.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /patients/1
  # PUT /patients/1.xml
  def update
    @patient = Patient.find(params[:id])

    respond_to do |format|
      if @patient.update_attributes(params[:patient])
        format.html { redirect_to(@patient, :notice => I18n.t("notifications.patients.update_success")) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @patient.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /patients/1
  # DELETE /patients/1.xml
  def destroy
    @patient = Patient.find(params[:id])
    @patient.destroy

    respond_to do |format|
      format.html { redirect_to(patients_url) }
      format.xml  { head :ok }
    end
  end
end
