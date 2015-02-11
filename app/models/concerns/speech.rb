module Speech
  # Splits the message into chunks of 100 characters so Google's voice translate
  # api will accept it and return an mp3, which is played with mpg123
  def say(message)
    chunk = '' # <= 100 characters
    for word in message.split(' ')
      if (chunk + ' ' + word).length > 100
        `mpg123 -q "http://translate.google.com/translate_tts?tl=en&q=#{chunk}"`
        chunk.clear
      end
      chunk += ' ' + word
    end
    `mpg123 -q "http://translate.google.com/translate_tts?tl=en&q=#{chunk}"`
  end
end