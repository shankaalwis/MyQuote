# app/models/user.rb
class User < ApplicationRecord
  # Adds password=, authenticate, and hashes password_digest
  has_secure_password

  # A user owns many quotes
  has_many :quotes, dependent: :destroy

  # Allowed account statuses
  STATUSES = %w[Active Suspended Banned].freeze

  # Basic validations
  validates :fname, :lname, :email, :status, presence: true
  validates :email, uniqueness: true
  validates :status, inclusion: { in: STATUSES }

  # Default role is non-admin
  attribute :is_admin, :boolean, default: false
end
