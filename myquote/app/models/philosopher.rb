# app/models/philosopher.rb
class Philosopher < ApplicationRecord
  # If a philosopher is deleted, keep quotes but clear philosopher_id
  has_many :quotes, dependent: :nullify

  # Many quotes are "Anonymous/Unknown".
  # Allow blank names; require at least one name if the other is blank.
  validates :first_name, presence: true, unless: -> { last_name.present? }
end
