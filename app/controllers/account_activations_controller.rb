class AccountActivationsController < ApplicationController
  before_action :load_user
  before_action :check_activated
  before_action :check_authenticated

  def edit
    @user.activate
    log_in @user
    flash[:success] = "Account activated!"
    redirect_to @user
  end

  private

  def load_user
    @user = User.find_by(email: params[:email])
    return if @user

    flash[:danger] = "User not found"
    redirect_to root_url
  end

  def check_activated
    return unless @user.activated

    flash[:danger] = "Account already activated"
    redirect_to root_url
  end

  def check_authenticated
    return if @user.authenticated?(:activation, params[:id])

    flash[:danger] = "Invalid activation link"
    redirect_to root_url
  end
end
