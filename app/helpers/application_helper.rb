module ApplicationHelper
  include Pagy::Frontend
  include Pagy::Backend
  def full_title page_title = ""
    base_title = t("titles.base")

    if page_title.empty?
      base_title
    else
      "#{page_title} | #{base_title}"
    end
  end
end
