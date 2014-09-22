ActionMailer::Base.smtp_settings = {
  :address        => "smtp.gmail.com",
  :port           => 587,
  :doman          => "http://peaceful-lowlands-7052.herokuapp.com/",
  :user_name      => ENV['EMAIL'],
  :password       => ENV['EMAIL_PASSWORD'],
  :authentication => "plain",
  :enable_starttls_auto => true
}