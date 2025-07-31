class ContactPagesController < ApplicationController
  def home
    if logged_in?
      @micropost = current_user.microposts.build
      @pagy, @feed_items = pagy current_user.feed, items: 10
    else
      @pagy, @feed_items = pagy_array([])
    end
  end

  def help; end

  def about; end

  def contact; end
end
