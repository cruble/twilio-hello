
class NotificationsController < ApplicationController
  include Webhookable
  skip_before_action :verify_authenticity_token
  @@all_responses = []

 
  def index
  end 

  def notify
    client = Twilio::REST::Client.new ENV['TWILIO_ACCOUNT_SID'], ENV['TWILIO_AUTH_TOKEN']
    message = client.messages.create from: '13238798398', to: ENV['CHAD_PHONE'], body: 'Learning to send SMS you are.', status_callback: 'https://ba74edc7.ngrok.io/twilio/status'
    
    render plain: message.status

  end

# you can send a text to a group, by iterating over a hash 
  def banana
    client = Twilio::REST::Client.new ENV['TWILIO_ACCOUNT_SID'], ENV['TWILIO_AUTH_TOKEN']
         
        from = "+13238798398" # Your Twilio number
         
        friends = {
        '+17327663542' => "Ian",
        '+13472289044' => "Julian",
        '+19179684122' => "Chad", 
        '+17579037395' => "Findlay"
        }
        friends.each do |key, value|
          client.account.messages.create(
            :from => from,
            :to => key,
            :body => "Hey #{value}, Monkey party at 6PM. Bring Bananas!"
          )
        end
    render 'index'
  end 

  def auto_reply
    twiml = Twilio::TwiML::Response.new do |r|
      r.Message "Hey Monkey. Thanks for the message!"
    end
    render_twiml twiml
  end 

  def auto_nsa
    session["counter"] ||= 0
    sms_count = session["counter"]
    if sms_count == 0
      message = "Hello, thanks for the new message."
    else
      message = "Hello, thanks for message number #{sms_count + 1}"
    end
      twiml = Twilio::TwiML::Response.new do |r|
        r.Message message
      end
    session["counter"] += 1
    render_twiml twiml   
  end 

  def incoming

    friends = {
        '+17327663542' => "Ian",
        '+13472289044' => "Julian",
        '+19179684122' => "Chad", 
        '+17579037395' => "Findlay"
        }
    # Grab the phone number from incoming Twilio params
    @phone_number = params[:From]

    # Find the subscriber associated with this number or create a new one
    # @new_subscriber = Subscriber.exists?(:phone_number => @phone_number) === false
    # @subscriber = Subscriber.first_or_create(:phone_number => @phone_number)

    @body         = params[:Body]
    @from_number  = params[:From]

    @number_name = friends[@from_number]


    output = @body
    @@all_responses << @body
    @@all_responses << @from_number
    @@all_responses << @number_name

    @responses = @@all_responses
    # Render the TwiML response
    respond(output)

    # render 'index'
  end

  def respond(message)
      response = Twilio::TwiML::Response.new do |r|
        r.Message message
      end
      render text: response.text
  end



 
end