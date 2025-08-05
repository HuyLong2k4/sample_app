class UsersController < ApplicationController
  before_action :logged_in_user, except: %i(show new create)
  before_action :load_user, except: %i(index new create)
  before_action :admin_user, only: :destroy

  # GET /users/:id
  def show; end

  # GET /users/new
  def new
    @user = User.new
  end

  # GET /users
  def index
    @pagy, @users = pagy User.newest, items: Settings.page_10
  end

  # POST /users
  def create
    @user = User.new user_params
    if @user.save
      reset_session
      log_in @user

      flash[:success] = t(".welcome")
      redirect_to @user, status: :see_other
    else
      render :new, status: :unprocessable_entity
    end
  end

  # GET /users/:id/edit
  def edit; end

  # PATCH /users/:id
  def update
    if @user.update user_params
      # Handle a successful update.
      flash[:success] = t(".profile_updated")
      redirect_to @user, status: :see_other
    else
      render :edit, status: :unprocessable_entity
    end
  end

  # DELETE /users/:id
  def destroy
    if @user.destroy
      flash[:success] = t(".deleted")
    else
      flash[:danger] = t(".delete_fail")
    end
    redirect_to users_path
  end

  private

  def load_user
    @user = User.find_by id: params[:id]
    return if @user

    flash[:warning] = t("contact.users.not_found")
    redirect_to root_path
  end

  def user_params
    params.require(:user).permit(User::USER_PERMIT)
  end

  # Before filters
  # Confirms a logged-in user.
  def logged_in_user
    return if logged_in?

    store_location
    flash[:danger] = t(".updated_danger")
    redirect_to login_url
  end

  # Confirms the correct user.
  def correct_user
    return if current_user?(@user)

    flash[:error] = t(".errors")
    redirect_to root_url
  end

  def admin_user
    return if current_user.admin?

    flash[:error] = t("admin.permission_denied")
    redirect_to root_path and return
  end
end
