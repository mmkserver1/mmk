class MeasurementsController < ApplicationController
  before_filter :authenticate_user!
  before_filter :find_patient

  # GET /measurements/cardiograms
  def index
    @collection = current_user_or_patient.send(collection_name).all

    instance_variable_set "@"+collection_name, @collection
    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @collection.map { |i| i.attributes.merge(:current_thresholds => i.current_thresholds(current_user, @patient))}.to_xml(:root => "measurements-#{collection_name}") }
    end
  end

  # GET /measurements/last
  def last
    @collection = []
    [:temperatures, :cardiograms, :bloodpressures, :glucoses].each do |type|
      if measurement = current_user_or_patient.send(type.to_s).order(:created_at).last
        @collection << { type.to_s.singularize => { :id => measurement.id, :date => measurement.created_at } }
      else
        @collection << { type.to_s.singularize => nil }
      end

    end

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @collection.to_xml(:root => 'measurements') }
    end
  end

  # GET /measurements/cardiograms/1
  def show
    @resource = current_user_or_patient.send(collection_name).find(params[:id])

    instance_variable_set "@"+resource_name, @resource
    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @resource.attributes.merge(:current_thresholds => @resource.current_thresholds(current_user, @patient)).to_xml(:root => resource_name)}
    end
  end

  # GET /measurements/cardiograms/new
  def new
    @resource = current_user_or_patient.send(collection_name).new

    instance_variable_set "@"+resource_name, @resource
    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @resource }
    end
  end

  # GET /measurements/cardiograms/1/edit
  def edit
    @resource = current_user_or_patient.send(collection_name).find(params[:id])
    instance_variable_set "@"+resource_name, @resource
  end

  # POST /measurements/cardiograms
  def create
    @resource = current_user_or_patient.send(collection_name).new(params["measurements_#{resource_name}"])
    @resource.client_device = ClientDevice.create(params[:client_device])
    @resource.medical_device = MedicalDevice.create(params[:medical_device])

    instance_variable_set "@"+resource_name, @resource
    respond_to do |format|
      if @resource.save
        format.html { redirect_to(current_user.is_patient? ? @resource : [current_user_or_patient, @resource], :notice => t("notifications.measurements.create_success")) }
        format.xml  { render :xml => @resource }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @resource.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /measurements/cardiograms/1
  def update
    @resource = current_user_or_patient.send(collection_name).find(params[:id])

    instance_variable_set "@"+resource_name, @resource
    respond_to do |format|
      if @resource.update_attributes(params["measurements_#{resource_name}"])
        format.html { redirect_to(current_user.is_patient? ? @resource : [current_user_or_patient, @resource], :notice => t("notifications.measurements.update_success")) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @resource.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /measurements/cardiograms/1
  def destroy
    
    unless params[:id]=='all'
      @resource = current_user_or_patient.send(collection_name).find(params[:id])
      @resource.destroy
    else
      @resource = current_user_or_patient.send(collection_name).destroy_all
    end

    respond_to do |format|
      format.html { redirect_to(current_user.is_patient? ? [:measurements, collection_name] : [current_user_or_patient, :measurements, collection_name]) }
      format.xml  { head :ok }
    end
  end

  
  private

  def find_patient
    @patient = current_user.is_doctor? ? current_user.patients.find(params[:patient_id]) : nil
  end

  def resource_class
    case name = params[:measurement_name]
    when :temperatures then Measurements::Temperature
    when :cardiograms then Measurements::Cardiogram
    else raise "`#{name}` measurement is not found"
    end
  end

  def collection_name
    params[:measurement_name].to_s.pluralize
  end
  helper_method :collection_name

  def resource_name
    params[:measurement_name].to_s.singularize
  end
  helper_method :resource_name

  %w[ url path ].each do |type|
    define_method "resource_#{type}" do |*args|
      send "measurements_#{resource_name}_#{type}", *args
    end
    helper_method "resource_#{type}"

    define_method "new_resource_#{type}" do |*args|
      send "new_measurements_#{resource_name}_#{type}", *args
    end
    helper_method "new_resource_#{type}"

    define_method "edit_resource_#{type}" do |*args|
      send "edit_measurements_#{resource_name}_#{type}", *args
    end
    helper_method "edit_resource_#{type}"

    define_method "collection_#{type}" do |*args|
      send "measurements_#{collection_name}_#{type}", *args
    end
    helper_method "collection_#{type}"
  end

end

