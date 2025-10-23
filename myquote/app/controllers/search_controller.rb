# app/controllers/search_controller.rb
class SearchController < ApplicationController
  # Public search by category (only public quotes)
  def index
    @q = params[:q].to_s.strip
    @quotes = if @q.blank?
      [] # nothing to search
    else
      # Join categories to filter by name; only public visibility
      Quote.joins(:categories, :user).includes(:philosopher, :categories)
           .where('categories.name LIKE ?', "%#{@q}%")
           .where(is_public: true)
           .distinct
    end
  end
end
