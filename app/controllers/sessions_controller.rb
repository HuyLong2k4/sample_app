class SessionsController < ApplicationController
  REMEMBER = 1
  before_action :load_user, only: :create
  before_action :check_authentication, only: :create

  # GET /login
  def new; end

  # POST /login
  def create
    user = find_user
    if user&.authenticate(user_password)
      if user.activated?
        successful_login(user)
      else
        handle_unactivated_user
      end
    else
      handle_invalid_login
    end
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

  def find_user
    User.find_by(email: params.dig(:session, :email)&.downcase)
  end

  def user_password
    params.dig(:session, :password)
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

  def handle_unactivated_user
    flash[:warning] =
      "Account not activated. Check your email for the activation link."
    redirect_to root_url, status: :see_other
  end

  def handle_invalid_login
    flash.now[:danger] = t("invalid_email_password_combination")
    render :new, status: :unprocessable_entity
  end
end
