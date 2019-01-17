class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  before_action :require_authentication
  helper_method :current_user

  def require_authentication
    unless session[:current_user] && current_user
      redirect_to new_session_path, alert: 'Log in to continue'
    end
  end

  def current_user
    @current_user ||= User.find session[:current_user]
  end

  def socket_id#use for ignoring pusher on self page
    session[:socket_id] = params[:socket_id]
  end
end
