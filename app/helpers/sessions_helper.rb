module SessionsHelper
  # Có 5 cách phổ biến để lưu trữ session_storage
  # Cách hiện tại là dùng Cookie Store (mặc định của Rails), 
  # session được lưu trong cookie ở trình duyệt người dùng.
  def log_in user
    # ghi thông tin vào hash session, session được mã hóa hash 
    # lưu thành cookie rails_tutorial_sesion trên trình duyệt
    session[:user_id] = user.id
  end

  # Returns the current logged-in user (if any).
  def current_user
    @current_user ||= User.find_by id: session[:user_id]
  end

  # Returns true if the user is logged in, false otherwise.
  def logged_in?
    current_user.present?
  end

  # Logs out the current user.
  def log_out
    reset_session
    @current_user = nil
  end
end
