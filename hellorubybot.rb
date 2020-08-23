require 'telegram/bot'

# Telegram Bot Token
token = ''

# Bot Program
Telegram::Bot::Client.run(token) do |bot|
bot.listen do |message|
    case message
        when Telegram::Bot::Types::Message
            case message.text
                when '/start'
                  bot.api.send_message(chat_id: message.chat.id, text: "Welcome #{message.chat.first_name} 😊")
                  bot.api.send_message(chat_id: message.chat.id, text: "Use /help for all available commands.")

                when '/audio'
                    # https://freesound.org/people/pepezabala/sounds/122920/
                    bot.api.send_audio(chat_id: message.chat.id, audio: Faraday::UploadIO.new('ruby.mp3', 'audio/mp3'))
                when '/document'
                    # https://www.ruby-lang.org/en/about/logo/
                    bot.api.send_document(chat_id: message.chat.id, audio: Faraday::UploadIO.new('ruby.pdf', 'application/pdf'))

                when '/map'
                    bot.api.send_location(chat_id: message.chat.id, latitude: 37.414487, longitude: -122.077409)

                when '/photo'
                    # https://www.ruby-lang.org/en/about/logo/
                    bot.api.send_photo(chat_id: message.chat.id, photo: Faraday::UploadIO.new('ruby.png', 'image/png'), caption: "Ruby\nA PROGRAMMER'S BEST FRIEND")

                when '/question'
                    question = 'Ruby was created by?'
                    answers_keyboard = [
                                Telegram::Bot::Types::InlineKeyboardButton.new(text: 'Rasmus Lerdorf', callback_data: 'rasmus'),
                                Telegram::Bot::Types::InlineKeyboardButton.new(text: 'Yukihiro Nozuyama', callback_data: 'nozuyama'),
                                Telegram::Bot::Types::InlineKeyboardButton.new(text: 'Yukihiro Matsumoto', callback_data: 'matsumoto'),
                                Telegram::Bot::Types::InlineKeyboardButton.new(text: 'Tim Berners-Lee', callback_data: 'berners'),
                            ]
                    answers = Telegram::Bot::Types::InlineKeyboardMarkup.new(inline_keyboard: answers_keyboard)
                    bot.api.send_message(chat_id: message.chat.id, text: question, reply_markup: answers)

                when '/sticker'
                    bot.api.send_sticker(chat_id: message.chat.id, sticker: "CAACAgQAAxkBAAEBPidfQcraNsyn9GGAzb6AJy0BLt2oCAACAQADSDJJGqYPV6FxnTLNGwQ")

                when '/textformat'
                  bot.api.send_message(chat_id: message.chat.id, text: "<code>This is a monospace text.</code>\n<b>This is a bold text.</b>\n<i>This is a italic text.</i>\n<u>This is a underlined text.</u>\n<s>This is a strikethrough text.</s>\n<a href='https://www.ruby-lang.org/'>This is a inline URL.</a>", parse_mode: "HTML")

                when '/url'
                    bot.api.send_message(chat_id: message.chat.id, text: "https://www.ruby-lang.org")


                when '/urlbutton'
                    keyboard = [Telegram::Bot::Types::InlineKeyboardButton.new(text: 'Ruby 💎', url: 'https://www.ruby-lang.org')]
                    markup = Telegram::Bot::Types::InlineKeyboardMarkup.new(inline_keyboard: keyboard)
                    bot.api.send_message(chat_id: message.chat.id, text: "Inline Keyboard URL Button", reply_markup: markup)

                when '/video'
                    # https://www.ruby-lang.org/en/about/logo/
                    bot.api.send_video(chat_id: message.chat.id, video: Faraday::UploadIO.new('ruby.mp4', 'video/mp4'))
                when '/voice'
                    # https://freesound.org/people/pepezabala/sounds/122920/
                    bot.api.send_voice(chat_id: message.chat.id, voice: Faraday::UploadIO.new('ruby.ogg', 'audio/ogg'))

                when '/stop'
                    bot.api.send_message(chat_id: message.chat.id, text: 'Sorry to see you go 😣')
                
                when '/help'
                    bot.api.send_message(chat_id: message.chat.id, text: "/start - Start\n
/audio - Send Audio\n
/document - Send Document\n
/map - Send Map\n
/photo - Send Photo\n
/question - Question\n
/sticker - Send Sticker\n
/textformat - Text Formatting\n
/url - Send URL\n
/urlbutton - Send URL Button\n
/video - Send Video\n
/voice - Send Voice\n
/stop - Stop Bot")
                else
                   bot.api.send_message(chat_id: message.chat.id, text: "Invalid Command")
                end

        # Check for CallbackQuery
        when Telegram::Bot::Types::CallbackQuery
            # Here you can handle your question callbacks from inline buttons
            if message.data == 'matsumoto'
              bot.api.send_message(chat_id: message.from.id, text: "Correct ✅")
            else
              bot.api.send_message(chat_id: message.from.id, text: "Wrong ❌")
            end

        # Check for InlineQuery
        when Telegram::Bot::Types::InlineQuery
            results = [
              [1, 'First article', 'This is a example of a inline query'],
              [2, 'Second article', 'Another interesting text here.'],
              [3, 'Third article', 'Very interesting text goes here.'],
            ].map do |arr|
              Telegram::Bot::Types::InlineQueryResultArticle.new(
                id: arr[0],
                title: arr[1],
                input_message_content: Telegram::Bot::Types::InputTextMessageContent.new(message_text: arr[2])
              )
            end
            bot.api.answer_inline_query(inline_query_id: message.id, results: results)

        end
    end
end
