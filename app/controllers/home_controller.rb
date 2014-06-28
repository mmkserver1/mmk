class HomeController < ApplicationController
  before_filter :authenticate_user!, :except => :show

  def show
    render :template => "home/#{params[:id]}"
  end


  def index
    user = User.find_by_id(current_user)

    if user.is_patient?
      render :patient
    elsif user.is_doctor?
      redirect_to patients_path
    end
  end

end
