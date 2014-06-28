class ApiV2::Patient::BaseController < ApiV2::BaseController
  before_filter :authenticate_api_v2_patient!

  alias_method :current_patient, :current_api_v2_patient
end
