class ApplicationController < ActionController::Base
  before_action :authorize

  protected

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
