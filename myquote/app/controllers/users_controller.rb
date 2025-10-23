# app/controllers/users_controller.rb
class UsersController < ApplicationController
  # Load user for show/edit/update/destroy
  before_action :set_user, only: %i[ show edit update destroy ]
  # Guests can sign up; all else requires login
  before_action :require_login, except: %i[new create]
  # Only admins can list and delete users
  before_action :require_admin, only: %i[index destroy]
  # Users can only see/edit themselves (admins can see anyone)
  before_action :require_owner_or_admin, only: %i[show edit update]

  def index
    # Admin-only list of users
    @users = User.order(:lname, :fname)
  end

  def show; end

  def new
    # Default new sign-ups are Active, non-admin
    @user = User.new(status: 'Active', is_admin: false)
  end

  def edit; end

  def create
    # Only safe fields from the signup form
    @user = User.new(user_params_for_create)
    @user.status ||= 'Active'
    @user.is_admin = false # prevent role escalation on signup

    if @user.save
      # Auto-login after successful signup
      session[:user_id] = @user.id
      redirect_to userhome_path, notice: "Welcome!"
    else
      render :new, status: :unprocessable_entity
    end
  end

  def update
    # Admins may change status/role; users cannot
    permitted = is_administrator? ? admin_update_params : user_update_params
    if @user.update(permitted)
      redirect_to @user, notice: "Updated."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    # Admin deletes user (cascades quotes)
    @user.destroy
    redirect_to users_url, notice: "User deleted."
  end

  private
    def set_user
      @user = User.find(params[:id])
    end

    def require_owner_or_admin
      unless is_administrator? || current_user == @user
        redirect_to root_path, alert: 'Not authorized.'
      end
    end

    # Strong params: what signup can send
    def user_params_for_create
      params.require(:user).permit(:fname, :lname, :email, :password)
    end

    # Strong params: what a standard user can update
    def user_update_params
      params.require(:user).permit(:fname, :lname, :email, :password)
    end

    # Strong params: what an admin can update
    def admin_update_params
      params.require(:user).permit(:fname, :lname, :email, :password, :status, :is_admin)
    end
end
