class ApplicationController < ActionController::Base
  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  allow_browser versions: :modern
  before_action :require_login

  private
  
  def current_user
    @current_user ||= User.find_by(id: session[:user_id]) if session[:user_id]
  end
  helper_method :current_user
  
  def logged_in?
    !!current_user
  end
  helper_method :logged_in?
  
  def require_login
    unless logged_in?
      store_location
      redirect_to login_path, alert: "Please log in to access this page."
    end
  end
  
  def store_location
    session[:return_to] = request.fullpath if request.get?
  end
  
  def redirect_back_or_default(default)
    redirect_to(session.delete(:return_to) || default)
  end
end
