module SessionsHelper
  def log_in user
    session[:user_id] = user.id
  end

  # Returns the current logged-in user (if any).
  def current_user
    if (user_id = session[:user_id])
      @current_user ||= User.find_by id: user_id
    elsif (user_id = cookies.signed[:user_id])
      @current_user ||= user_from_cookie(user_id)
    end
  end

  # Forgets a persistent session.
  def forget user
    user.forget
    cookies.delete :user_id
    cookies.delete :remember_token
  end

  # Returns true if the user is logged in, false otherwise.
  def logged_in?
    current_user.present?
  end

  # Logs out the current user.
  def log_out
    forget(current_user)
    session.delete  :user_id
    @current_user = nil
  end

  # Remembers a user in a persistent session.
  def remember user
    user.remember
    cookies.permanent.signed[:user_id] = user.id
    cookies.permanent[:remember_token] = user.remember_token
  end

  private

  def user_from_cookie(user_id)
    user = User.find_by(id: user_id)
    if user&.authenticated?(cookies[:remember_token])
      log_in(user)
      user
  end
end
