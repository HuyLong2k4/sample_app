class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  include SessionsHelper
  
  before_action :set_locale

  def set_locale
    I18n.locale =
      if I18n.available_locales.map(&:to_s).include?(params[:locale])
        params[:locale]
      else
        I18n.default_locale
      end
  end

  def default_url_options
    {locale: I18n.locale}
  end
end
