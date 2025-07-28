class SessionsController < ApplicationController
  REMEMBER_CHECKED = "1".freeze

  before_action :load_user, only: :create
  before_action :check_authentication, only: :create

  def new; end

  def create
    forwarding_url = session[:forwarding_url]
    reset_session
    log_in @user
    params.dig(:session, :remember_me) == REMEMBER_CHECKED ? remember(@user) : forget(@user)
    redirect_to forwarding_url || @user
  end

  def destroy
    log_out if logged_in?
    redirect_to root_url, status: :see_other
  end

  private

  def load_user
    @user = User.find_by(email: params.dig(:session, :email)&.downcase)
    unless @user
      flash.now[:danger] = t(".invalid")
      render :new, status: :unprocessable_entity
    end
  end

  def check_authentication
    unless @user&.authenticate(params.dig(:session, :password))
      flash.now[:danger] = t(".invalid")
      render :new, status: :unprocessable_entity
    end
  end
end
