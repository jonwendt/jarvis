module Speech
  extend ActiveSupport::Concern

  def say(message)
    self.class.say(message)
  end

  def play_song(path)
    self.class.play_song(path)
  end

  module ClassMethods
    # Splits the message into chunks of 100 characters so Google's voice translate
    # api will accept it and return an mp3, which is played with mpg123
    # FIXME - will not work with >100 strings with no spaces
    # FIXME - change to download all mp3's before starting to play messages, then play them quicker.
    def say(message)
      `amixer set PCM -- -500`
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

    def play_song(path)
      `amixer set PCM -- -1500`
      `mpg123 "#{path}"`
    end

  end
end
