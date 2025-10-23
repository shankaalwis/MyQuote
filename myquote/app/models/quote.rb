# app/models/quote.rb
class Quote < ApplicationRecord
  # Owner and source (philosopher can be optional)
  belongs_to :user
  belongs_to :philosopher, optional: true

  # Categories via join model
  has_many :quote_categories, dependent: :destroy
  has_many :categories, through: :quote_categories

  # Required fields and valid booleans
  validates :quote_text, presence: true
  validates :is_public, inclusion: { in: [true, false] }

  # Custom validation to ensure at least one category
  validate  :must_have_at_least_one_category

  private

  def must_have_at_least_one_category
    # categories.blank? covers unsaved association; quote_categories for form posting
    if categories.blank? && quote_categories.blank?
      errors.add(:base, 'Select at least one category')
    end
  end
end
