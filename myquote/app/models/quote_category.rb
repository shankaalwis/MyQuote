# app/models/quote_category.rb
class QuoteCategory < ApplicationRecord
  # Standard many-to-many join
  belongs_to :quote
  belongs_to :category

  # Ensure a category is chosen
  validates :category_id, presence: true
end
