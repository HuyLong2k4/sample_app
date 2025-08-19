class PasswordResetsController < ApplicationController
  PASSWORD_PERMIT = %i(password password_confirmation).freeze

  before_action :load_user_for_create, only: :create
  before_action :load_user, only: %i(edit update)
  before_action :valid_user, only: %i(edit update)
  before_action :check_expiration, only: %i(edit update)
  before_action :check_empty_password, only: :update

  # GET /password_resets/new
  def new; end

  # GET /password_resets/:id/edit
  def edit; end

  # POST /password_resets
  def create
    @user.create_reset_digest
    @user.send_password_reset_email
    flash[:info] = t("password_resets.create.success")
    redirect_to root_url
  end

  # PATCH/PUT /password_resets/:id
  def update
    if @user.update(user_params)
      reset_session
      log_in @user
      flash[:success] = t("password_resets.update.success")
      redirect_to @user
    else
      render :edit, status: :unprocessable_entity
    end
  end

  private

  def load_user_for_create
    @user = User.find_by email: params.dig(:password_reset, :email)&.downcase
    return if @user

    flash.now[:danger] = t("password_resets.create.not_found")
    render :new, status: :unprocessable_entity
  end

  def load_user
    @user = User.find_by email: params[:email]
    return if @user

    flash[:danger] = t("password_resets.errors.user_not_found")
    redirect_to root_url
  end

  def valid_user
    return if @user&.activated? && @user&.authenticated?(:reset, params[:id])

    flash[:danger] = t("password_resets.errors.user_not_active")
    redirect_to root_url
  end

  def check_expiration
    return unless @user.password_reset_expired?

    flash[:danger] = t("password_resets.errors.expired")
    redirect_to new_password_reset_url
  end

  def check_empty_password
    return if user_params[:password].present?

    @user.errors.add(:password, t("password_resets.update.empty_password"))
    render :edit, status: :unprocessable_entity
  end

  def user_params
    params.require(:user).permit PASSWORD_PERMIT
  end
end
