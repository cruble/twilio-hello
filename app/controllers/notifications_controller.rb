
class NotificationsController < ApplicationController
 
  skip_before_action :verify_authenticity_token
 
  def notify
    client = Twilio::REST::Client.new ENV['TWILIO_ACCOUNT_SID'], ENV['TWILIO_AUTH_TOKEN']
    message = client.messages.create from: '13238798398', to: ENV['CHAD_PHONE'], body: 'Learning to send SMS you are.'
    render plain: message.status

  end
 
end