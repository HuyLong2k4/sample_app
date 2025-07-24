class User < ApplicationRecord
  has_secure_password

  NAME_MAX_LENGTH = 50
  EMAIL_MAX_LENGTH = 255
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  USER_PERMIT =
    %i(name email password password_confirmation birthday gender)
    .freeze

  enum gender: {female: 0, male: 1, other: 2}

  validates :name, presence: true, length: {maximum: NAME_MAX_LENGTH}

  validates :email,
            presence: true,
            length: {maximum: EMAIL_MAX_LENGTH},
            format: {with: VALID_EMAIL_REGEX},
            # case_sensitive: false disables case sensitivity.
            # For example, "User@example.com" and "user@example.com"
            # will be considered the same.
            uniqueness: {case_sensitive: false}

  validates :birthday, presence: true
  validates :gender, presence: true

  # Returns the hash digest of the given string.
  def self.digest string
    cost = if ActiveModel::SecurePassword.min_cost
             BCrypt::Engine::MIN_COST
           else
             BCrypt::Engine.cost
           end
    BCrypt::Password.create string, cost:
  end
end
