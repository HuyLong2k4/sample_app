class UsersController < ApplicationController
  before_action :load_user, only: :show

  def show; end

  private

  def load_user
    @user = User.find_by id: params[:id]
    return if @user

    flash[:warning] = t("contact.users.not_found")
    redirect_to root_path
  end
end
