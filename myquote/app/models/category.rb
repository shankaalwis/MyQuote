# app/models/category.rb
class Category < ApplicationRecord
  # Many-to-many with quotes through the join model
  has_many :quote_categories, dependent: :destroy
  has_many :quotes, through: :quote_categories

  # Category names must be unique
  validates :name, presence: true, uniqueness: true
end
