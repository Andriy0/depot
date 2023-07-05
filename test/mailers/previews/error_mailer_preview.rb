# Preview all emails at http://localhost:3000/rails/mailers/error_mailer
class ErrorMailerPreview < ActionMailer::Preview

  # Preview this email at http://localhost:3000/rails/mailers/error_mailer/invalid_record
  def invalid_record
    ErrorMailer.invalid_record
  end

end
