class UserMailer < ApplicationMailer
  def account_activation user
    @user = user
    mail to: user.email,
         subject: I18n.t("user_mailer.account_activation.subject")
  end

  def password_reset user
    @user = user
    mail to: user.email, subject: I18n.t("user_mailer.password_reset.subject")
  end

  def password_changed user
    @user = user
    @login_url = login_url
    mail to: user.email, subject: I18n.t("user_mailer.password_changed.subject")
  end
end
