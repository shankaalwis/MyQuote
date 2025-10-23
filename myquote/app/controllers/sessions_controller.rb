# app/controllers/sessions_controller.rb
class SessionsController < ApplicationController
  # GET /login
  def new
  end

  # POST /login
  def create
    user = User.find_by(email: params[:email].to_s.downcase.strip)

    if user&.authenticate(params[:password])
      case user.status
      when 'Active'
        session[:user_id] = user.id
        # Admins -> /admin, Standard users -> /
        if user.is_admin
          redirect_to admin_path, notice: 'Signed in as administrator.'
        else
          redirect_to root_path, notice: 'Signed in successfully.'
        end
      when 'Suspended', 'Banned'
        flash.now[:alert] = "Your account is #{user.status}. Please contact an administrator."
        render :new, status: :unprocessable_entity
      else
        flash.now[:alert] = "Your account status (#{user.status}) does not permit login."
        render :new, status: :unprocessable_entity
      end
    else
      flash.now[:alert] = 'Invalid email or password.'
      render :new, status: :unprocessable_entity
    end
  end

  # DELETE /logout
  def destroy
    reset_session
    redirect_to root_path, notice: 'Signed out.'
  end
end
