# app/controllers/quotes_controller.rb
class QuotesController < ApplicationController
  # Load quote for member actions
  before_action :set_quote, only: %i[ show edit update destroy ]
  # Guests can only view public quotes; all changes require login
  before_action :require_login, except: %i[index show]
  # Only owner or admin can edit/update/destroy
  before_action :require_owner_or_admin!, only: %i[edit update destroy]

  # GET /quotes
  def index
    if params[:q] == 'mine' && logged_in?
      # Show only current user's quotes
      @quotes = current_user.quotes.includes(:philosopher, :categories).order(created_at: :desc)
    else
      # Public list of quotes (only public ones)
      @quotes = Quote.includes(:philosopher, :categories, :user)
                     .where(is_public: true)
                     .order(created_at: :desc)
    end
  end

  # GET /quotes/1
  def show; end

  # GET /quotes/new
  def new
    # Pre-check public and link to current user; load dropdown data
    @quote = Quote.new(is_public: true, user: current_user)
    load_form_dependencies
  end

  # GET /quotes/1/edit
  def edit
    # Prepare dropdown data
    load_form_dependencies
  end

  # POST /quotes
  def create
    @quote = Quote.new(quote_params)
    @quote.user = current_user

    if @quote.save
      redirect_to @quote, notice: "Quote created."
    else
      load_form_dependencies
      render :new, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /quotes/1
  def update
    if @quote.update(quote_params)
      redirect_to @quote, notice: "Quote updated."
    else
      load_form_dependencies
      render :edit, status: :unprocessable_entity
    end
  end

  # DELETE /quotes/1
  def destroy
    @quote.destroy
    redirect_to quotes_path(q: 'mine'), notice: "Quote deleted."
  end

  private
    def set_quote
      @quote = Quote.find(params[:id])
    end

    def require_owner_or_admin!
      # Allow admins or the owner to manage the quote
      unless is_administrator? || @quote.user_id == current_user.id
        redirect_to root_path, alert: 'Not authorized.'
      end
    end

    # Strong params, including multi-select category_ids
    def quote_params
      params.require(:quote).permit(
        :quote_text, :publication_year, :owner_comment, :is_public, :philosopher_id,
        category_ids: [] # ← important for multi-select
      )
    end

    # Prepare collection options for selects
    def load_form_dependencies
      # Build "Full Name or Anonymous" list for select
      @philosophers = Philosopher.order(:last_name, :first_name).map { |p|
        [ [p.first_name, p.last_name].compact.join(' ').presence || 'Anonymous', p.id ]
      }
      # Category options as [name, id]
      @categories = Category.order(:name).pluck(:name, :id)
    end
end
