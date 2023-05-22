require 'telegram/bot'
require 'minitest/autorun'
require 'yaml'
require 'webmock'
require 'byebug'

WebMock.enable!

class TelegramPaymentBotTest < MiniTest::Test
  include WebMock::API

  def setup
    @bot = Telegram::Bot::Client.new('YOUR_BOT_TOKEN')
  end

  def test_start_command
        stub_request(:post, "https://api.telegram.org/botYOUR_BOT_TOKEN/sendMessage").
   with(
     body: {"chat_id"=>"123", "from"=>{"first_name"=>"John", "id"=>"123"}, "text"=>"/start"},
     headers: {
 	  'Accept'=>'*/*',
 	  'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3',
 	  'Content-Type'=>'application/x-www-form-urlencoded',
 	  'User-Agent'=>'Faraday v2.7.4'
     }).
   to_return(status: 200, body: { 'result' => { 'text' => 'Hello, John! Welcome to the payment bot.'} }.to_json, headers: {})


    response = @bot.api.send_message(chat_id: 123, text: '/start', from: { id: 123, first_name: 'John' })
    assert_equal 'Hello, John! Welcome to the payment bot.', response['result']['text']
  end

  def test_pay_command
        stub_request(:post, "https://api.telegram.org/botYOUR_BOT_TOKEN/sendMessage").
       with(
         body: {"chat_id"=>"123", "from"=>{"first_name"=>"John", "id"=>"123"}, "text"=>"/pay"},
         headers: {
     	  'Accept'=>'*/*',
     	  'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3',
     	  'Content-Type'=>'application/x-www-form-urlencoded',
     	  'User-Agent'=>'Faraday v2.7.4'
         }).
       to_return(status: 200, body: { 'result' => { 'text' => 'Please provide payment details.' } }.to_json, headers: {})

    response = @bot.api.send_message(chat_id: 123, text: '/pay', from: { id: 123, first_name: 'John' })
    assert_equal 'Please provide payment details.', response['result']['text']
  end

  def test_unknown_command
        stub_request(:post, "https://api.telegram.org/botYOUR_BOT_TOKEN/sendMessage").
       with(
         body: {"chat_id"=>"123", "from"=>{"first_name"=>"John", "id"=>"123"}, "text"=>"/unknown"},
         headers: {
     	  'Accept'=>'*/*',
     	  'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3',
     	  'Content-Type'=>'application/x-www-form-urlencoded',
     	  'User-Agent'=>'Faraday v2.7.4'
         }).
       to_return(status: 200, body: { 'result' => { 'text' => "I'm sorry, but I don't understand." } }.to_json, headers: {})

    response = @bot.api.send_message(chat_id: 123, text: '/unknown', from: { id: 123, first_name: 'John' })
    assert_equal "I'm sorry, but I don't understand.", response['result']['text']
  end

  # def test_error_handling
  #       stub_request(:any, /https:\/\/api.telegram.org\/bot.*\/.*/)
  #       .to_raise(StandardError.new('API request failed'))
  #
  #     assert_output(/An error occurred: API request failed/) do
  #       response = @bot.api.send_message(chat_id: 123, text: '/start', from: { id: 123, first_name: 'John' })
  #       assert_nil response
  #   end
  # end

end
