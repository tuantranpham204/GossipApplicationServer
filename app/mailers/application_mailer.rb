class ApplicationMailer < ActionMailer::Base
  from: if Rails.env.development? || Rails.env.test? then ENV['DEV_GMAIL_USERNAME'] elsif Rails.env.production? then ENV['PROD_GMAIL_USERNAME'] else "from@example.com" end
  layout "mailer"
end
