class ApiV2::BaseController < ActionController::Base

  protect_from_forgery

  respond_to :xml, :json

  before_filter :set_locale

  private

  def set_locale
    I18n.locale = params[:locale] || I18n.default_locale
  end

  def self.default_url_options(options={})
    options.merge({ :locale => I18n.locale })
  end

end
