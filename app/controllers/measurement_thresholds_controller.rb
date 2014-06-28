class MeasurementThresholdsController < ApplicationController
  before_filter :authenticate_user!
  before_filter :find_patient
  before_filter :find_measurement_threshold, :only => [:show, :edit, :update, :destroy]

  # GET /measurement_thresholds
  # GET /measurement_thresholds.xml
  def index
    @measurement_thresholds = current_doctor.send(collection_name).by_patient(@patient)

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @measurement_thresholds }
      format.json { render :json => @measurement_thresholds.each { |t| t.created_at = t.created_at.to_i * 1000 } }
    end
  end

  # GET /measurement_thresholds/new
  # GET /measurement_thresholds/new.xml
  def new
    @measurement_threshold = @patient.send(collection_name).new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @measurement_threshold }
    end
  end

  # POST /measurement_thresholds
  # POST /measurement_thresholds.xml
  def create
    @measurement_threshold = current_doctor.send(collection_name).new(params[resource_name.to_sym])
    @measurement_threshold.patient = @patient

    respond_to do |format|
      if @measurement_threshold.save
        format.html { redirect_to(:back, :notice => I18n.t("notifications.measurement_thresholds.create_success")) }
        format.xml  { render :xml => @measurement_threshold, :status => :created, :location => @measurement_threshold }
        @resource_name = resource_name
        format.js { render :create }
      else
        format.html { render :new }
        format.xml  { render :xml => @measurement_threshold.errors, :status => :unprocessable_entity }
      end
    end
  end

  # GET /measurement_thresholds/1
  # GET /measurement_thresholds/1.xml
  def show
    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @measurement_threshold }
    end
  end

  # GET /measurement_thresholds/1/edit
  def edit
  end

  # PUT /measurement_thresholds/1
  # PUT /measurement_thresholds/1.xml
  def update
    respond_to do |format|
      if @measurement_threshold.update_attributes(params[resource_name.to_sym])
        format.html { redirect_to([patient,@measurement_threshold], :notice => I18n.t("notifications.measurement_thresholds.update_success")) }
        format.xml  { head :ok }
        format.js { render :json => @measurement_threshold}
      else
        format.html { render :edit }
        format.xml  { render :xml => [patient,@measurement_threshold.errors], :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /measurement_thresholds/1
  # DELETE /measurement_thresholds/1.xml
  def destroy
    @measurement_threshold.destroy

    respond_to do |format|
      format.html { redirect_to(measurement_thresholds_url) }
      format.xml  { head :ok }
    end
  end

  private

  def collection_name
    params[:threshold_name].to_s.pluralize
  end
  helper_method :collection_name

  def resource_name
    params[:threshold_name].to_s.singularize
  end

  def find_patient
    @patient = Patient.find(params[:patient_id])
  end

  def find_measurement_threshold
    @measurement_threshold = @patient.measurement_thresholds.find(params[:id])
  end
end


