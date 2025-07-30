class User < ApplicationRecord
  attr_accessor :remember_token, :activation_token, :reset_token

  before_save :downcase_email
  before_create :create_activation_digest
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

  validates :password, presence: true,
      length: {minimum: Settings.digits.digit_6}, allow_nil: true

  # Returns the hash digest of the given string.
  def self.digest string
    cost = if ActiveModel::SecurePassword.min_cost
             BCrypt::Engine::MIN_COST
           else
             BCrypt::Engine.cost
           end
    BCrypt::Password.create string, cost:
  end

  def password_reset_expired?
    reset_sent_at < 2.hours.ago
  end

  class << self
    def new_token
      SecureRandom.urlsafe_base64
    end
  end

  def remember
    self.remember_token = User.new_token
    update_column :remember_digest, User.digest(remember_token)
  end

  def forget
    update_column :remember_digest, nil
  end

  scope :newest, ->{order(created_at: :desc)}

  # Returns true if the given token matches the digest.
  def authenticated? attribute, token
    digest = send "#{attribute}_digest"
    return false unless digest

    BCrypt::Password.new(digest).is_password? token
  end

  def create_reset_digest
    self.reset_token = User.new_token
    update_columns reset_digest: User.digest(reset_token),
                   reset_sent_at: Time.zone.now
  end

  def send_password_reset_email
    UserMailer.password_reset(self).deliver_now
  end

  # Activates an account.
  def activate
    update_columns activated: true, activated_at: Time.zone.now
  end

  # Sends activation email.
  def send_activation_email
    UserMailer.account_activation(self).deliver_now
  end

  private
  # Converts email to all lower-case.
  def downcase_email
    email.downcase!
  end

  # Creates and assigns the activation token and digest.
  def create_activation_digest
    self.activation_token = User.new_token
    self.activation_digest = User.digest(activation_token)
  end

  def send_password_changed_notification
    UserMailer.password_changed(self).deliver_now
  end
end
