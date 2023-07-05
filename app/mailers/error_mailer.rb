class ErrorMailer < ApplicationMailer
  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.error_mailer.invalid_record.subject
  #
  def invalid_record(error)
    @error = error

    mail to: 'admin@example.com', subject: 'Invalid record', from: 'Sam Ruby <depot@example.com>'
  end
end
