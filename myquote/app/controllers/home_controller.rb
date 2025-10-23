# app/controllers/home_controller.rb
class HomeController < ApplicationController
  # Only admins can see admin dashboard; users must be logged in to see their dashboard
  before_action :require_login, only: [:aindex, :uindex]
  before_action :require_admin, only: [:aindex]

  # Public home page with 10 latest public quotes
  def index
    @quotes = Quote.includes(:user, :philosopher, :categories)
                   .where(is_public: true)
                   .order(created_at: :desc)
                   .limit(10)
  end

  # Admin dashboard summary counts
  def aindex
    @users_count = User.count
    @quotes_count = Quote.count
    @categories_count = Category.count
    @philosophers_count = Philosopher.count
  end

  # Standard user dashboard summary
  def uindex
    @my_quotes_count = current_user.quotes.count
  end
end
