class ApplicationController < ActionController::Base
  before_action :authorize
  before_action :set_i18n_locale_from_params

  private

  def set_i18n_locale_from_params
    return unless params[:locale]

    if I18n.available_locales.map(&:to_s).include?(params[:locale])
      I18n.locale = params[:locale]
    else
      flash.now[:notice] = "#{params[:locale]} translation not available"
      logger.error flash[:notice]
    end
  end

  def authorize
    if request.format.symbol.in? %i[atom json xml]
      authenticate_or_request_with_http_basic do |name, password|
        User.find_by(name: name)&.authenticate password
      end
    else
      redirect_to login_url, notice: 'Please log in' unless User.find_by id: session[:user_id]
    end
  end
end
