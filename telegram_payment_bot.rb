require 'telegram/bot'
require 'yaml'
require 'byebug'

config = YAML.safe_load(File.read('config.yml'))
telegram_bot_token = config['telegram_bot_token']

Telegram::Bot::Client.run(telegram_bot_token) do |bot|
  bot.listen do |message|
    case message.text
    when '/start'
      bot.api.send_message(chat_id: message.chat.id, text: "Hello, #{message.from.first_name}! Welcome to the payment bot.")
    when '/pay'
      bot.api.send_message(chat_id: message.chat.id, text: "Please provide payment details.")
      # Add payment handling logic here
    else
      bot.api.send_message(chat_id: message.chat.id, text: "I'm sorry, but I don't understand.")
    end
  end
end
