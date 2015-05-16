module Speech
  extend ActiveSupport::Concern

  def say(message)
    self.class.say(message)
  end

  def whisper(message)
    self.class.whisper(message)
  end

  def play_song(path)
    self.class.play_song(path)
  end

  module ClassMethods
    # Splits the message into chunks of 100 characters so Google's voice translate
    # API will accept it and return an mp3, which is played with mpg123
    # FIXME - will not work with >100 strings with no spaces
    def speech(message)
      chunk = '' # <= 100 characters
      for word in message.split(' ')
        if (chunk + ' ' + word).length > 100
          `mpg123 -q "http://translate.google.com/translate_tts?tl=en&q=#{chunk}"`
          chunk.clear
          chunk = word
        else
          chunk += ' ' + word
        end
      end
      `mpg123 -q "http://translate.google.com/translate_tts?tl=en&q=#{chunk}"` unless chunk.blank?
      return message
    end

    # Downloads all chunks before playing them. This was an experiement to see if I could reduce
    # the lag between the mp3's playing, but it doesn't seem to help much (files are only ~25kb).
    def speech_download_first(message)
      chunks = []
      files = []
      chunk = '' # <= 100 characters

      # Split message into chunks of 100 characters
      message = message.split(' ')
      chunk = message.shift
      for word in message
        if (chunk + ' ' + word).length > 100
          chunks << chunk
          chunk = word
        else
          chunk += ' ' + word
        end
      end
      chunks << chunk unless chunk.blank?

      # Download each chunk
      url = URI.parse('http://translate.google.com/')
      Net::HTTP.start(url.host, url.port) do |http|
        chunks.each_with_index do |chunk, index|
          name = "chunk_#{index}.mp3"
          files << name
          f = open("#{name}", "w:ASCII-8BIT")
          http.request_get("/translate_tts?tl=en&q=#{URI::encode(chunk)}") do |resp|
            f.write(resp.body)
            f.close
          end
        end
      end

      # Play and delete each file
      files.each do |file_name|
        `mpg123 -q #{file_name}`
        File.delete(file_name)
      end
    end

    def say(message)
      `amixer set PCM -- -500`
      speech(message)
    end

    def whisper(message)
      `amixer set PCM -- -2500`
      speech(message)
    end

    def play_song(path)
      `amixer set PCM -- -1500`
      `mpg123 "#{path}"`
    end

  end
end
