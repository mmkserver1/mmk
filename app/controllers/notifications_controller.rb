class NotificationsController < ApplicationController


  # GET /notifications/from_date.xml
  # GET /notifications/from_date.json
 def from_date
   start_date = Time.zone.at params[:date].to_i
   patient = Patient.find params[:patient_id]
   patient ||= current_user_or_patient
   @notifications = patient.notifications.where("created_at > ?",start_date)

   respond_to do |format|
     format.xml  { render :xml => @notifications}
     format.json { render :json => { "items" => @notifications, "date" => Time.zone.now.to_i } }
   end
 end


  # GET /notifications
  # GET /notifications.xml
  def index
    @notifications = current_user_or_patient.notifications.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @notifications }
    end
  end

  # GET /notifications/1
  # GET /notifications/1.xml
  def show
    @notification = Notification.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @notification }
    end
  end

  # GET /notifications/new
  # GET /notifications/new.xml
  def new
    @notification = Notification.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @notification }
    end
  end

  # GET /notifications/1/edit
  def edit
    @notification = Notification.find(params[:id])
  end

  # POST /notifications
  # POST /notifications.xml
  def create
    @notification = Notification.new(params[:notification])

    respond_to do |format|
      if @notification.save
        format.html { redirect_to(@notification, :notice => I18n.t("notifications.notifications.create_success")) }
        format.xml  { render :xml => @notification, :status => :created, :location => @notification }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @notification.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /notifications/1
  # PUT /notifications/1.xml
  def update
    @notification = Notification.find(params[:id])

    respond_to do |format|
      if @notification.update_attributes(params[:notification])
        format.html { redirect_to(@notification, :notice => I18n.t("notifications.notifications.update_success")) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @notification.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /notifications/1
  # DELETE /notifications/1.xml
  def destroy
    @notification = Notification.find(params[:id])
    @notification.destroy

    respond_to do |format|
      format.html { redirect_to(notifications_url) }
      format.xml  { head :ok }
    end
  end
end
