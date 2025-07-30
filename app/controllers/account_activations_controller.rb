class AccountActivationsController < ApplicationController
  before_action :load_user
  before_action :check_activated
  before_action :check_authenticated

  # GET /account_activations/:id/edit
  def edit
    @user.activate
    log_in @user
    flash[:success] = t("account_activations.edit.success")
    redirect_to @user
  end

  private

  def load_user
    @user = User.find_by(email: params[:email])
    return if @user

    flash[:danger] = t("account_activations.load_user.not_found")
    redirect_to root_url
  end

  def check_activated
    return unless @user.activated

    flash[:danger] = t("account_activations.check_activated.already")
    redirect_to root_url
  end

  def check_authenticated
    return if @user.authenticated?(:activation, params[:id])

    flash[:danger] = t("account_activations.check_authenticated.invalid_link")
    redirect_to root_url
  end
end
