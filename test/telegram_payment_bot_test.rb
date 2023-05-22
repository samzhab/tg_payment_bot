require 'telegram/bot'
require 'minitest/autorun'
require 'yaml'
require 'byebug'

config = YAML.safe_load(File.read('config.yml'))
telegram_bot_token = config['telegram_bot_token']
byebug

class TelegramPaymentBotTest < MiniTest::Test
  def setup
    @bot = Telegram::Bot::Client.new(telegram_bot_token)
  end
  # Test methods remain the same
  def test_start_command
    response = @bot.api.send_message(chat_id: 123, text: '/start', from: { id: 123, first_name: 'John' })
    assert_equal "Hello, John! Welcome to the payment bot.", response['result']['text']
  end

  def test_pay_command
    response = @bot.api.send_message(chat_id: 123, text: '/pay', from: { id: 123, first_name: 'John' })
    assert_equal "Please provide payment details.", response['result']['text']
  end

  def test_unknown_command
    response = @bot.api.send_message(chat_id: 123, text: '/unknown', from: { id: 123, first_name: 'John' })
    assert_equal "I'm sorry, but I don't understand.", response['result']['text']
  end
end
