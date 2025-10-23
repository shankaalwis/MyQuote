# app/controllers/application_controller.rb
class ApplicationController < ActionController::Base
  # Make these helper methods available inside views
  helper_method :current_user, :logged_in?, :is_administrator?

  private

  # Returns currently logged-in user (or nil)
  def current_user
    return @current_user if defined?(@current_user)
    @current_user = User.find_by(id: session[:user_id])
  end

  # Convenience boolean for auth checks
  def logged_in?
    current_user.present?
  end

  # Require any logged-in user
  def require_login
    unless logged_in?
      redirect_to login_path, alert: 'Please sign in first.'
    end
  end

  # Is the current user an admin?
  def is_administrator?
    logged_in? && current_user.is_admin
  end

  # Require admin user
  def require_admin
    unless is_administrator?
      redirect_to root_path, alert: 'Admin only.'
    end
  end
end
