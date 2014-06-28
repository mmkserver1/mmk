class ApiV2::Doctor::BaseController < ApiV2::BaseController
  before_filter :authenticate_api_v2_doctor!

  alias_method :current_doctor, :current_api_v2_doctor
end
