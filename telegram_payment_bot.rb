require 'telegram/bot'
require 'yaml'
require 'webmock'

WebMock.disable_net_connect!(allow_localhost: true)

config = YAML.safe_load(File.read('config.yml'))
telegram_bot_token = config['telegram_bot_token']

Telegram::Bot::Client.run(token: telegram_bot_token) do |bot|
  if defined?(WebMock)
    bot.api.extend(WebMock::API)
    bot.api.stub_request_pattern = WebMock::StubRequestPattern
  end

  bot.listen do |message|
    begin
      case message.text
      when '/start'
        bot.api.send_message(chat_id: message.chat.id, text: "Hello, #{message.from.first_name}! Welcome to the payment bot.")
      when '/pay'
        bot.api.send_message(chat_id: message.chat.id, text: "Please provide payment details.")
        # Add payment handling logic here
      else
        bot.api.send_message(chat_id: message.chat.id, text: "I'm sorry, but I don't understand.")
      end
    rescue StandardError => e
      puts "An error occurred: #{e.message}"
      # Handle error gracefully, e.g., log error, send error message to user, etc.
    end
  end
end
