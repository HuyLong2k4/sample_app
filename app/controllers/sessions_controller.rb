class SessionsController < ApplicationController
  REMEMBER = 1

  before_action :load_user, only: :create
  before_action :check_authentication, only: :create
  before_action :check_activated, only: :create

  # GET /login
  def new; end

  # POST /login
  def create
    successful_login(@user)
  end

  # DELETE /logout
  def destroy
    log_out if logged_in?
    redirect_to root_url, status: :see_other
  end

  private

  def load_user
    @user = User.find_by(email: params.dig(:session, :email)&.downcase)
    return if @user

    flash.now[:danger] = t(".invalid")
    render :new, status: :unprocessable_entity
  end

  def check_authentication
    return if @user.authenticate(params.dig(:session, :password))

    flash.now[:danger] = t(".invalid")
    render :new, status: :unprocessable_entity
  end

  def check_activated
    return if @user.activated?

    flash[:warning] = t("sessions.create.not_activated")
    redirect_to root_url, status: :see_other
  end

  def remember_me_selected?
    params.dig(:session, :remember_me).to_i == REMEMBER
  end

  def successful_login user
    forwarding_url = session[:forwarding_url]
    reset_session
    remember_me_selected? ? remember(user) : forget(user)
    log_in user
    redirect_to forwarding_url || user
  end
end
