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

  def say_time
    self.class.say("The time is now #{Time.now.in_time_zone.strftime('%-l:%M %P')}")
  end

  module ClassMethods
    def speech(message)
      chunk = '' # <= 100 characters
      for word in message.split(' ')
        if (chunk + ' ' + word).length > 100
          `mpg123 -q "http://tts-api.com/tts.mp3?q=#{chunk}"`
          chunk.clear
          chunk = word
        else
          chunk += ' ' + word
        end
      end
      `mpg123 -q "http://tts-api.com/tts.mp3?q=#{chunk}"` unless chunk.blank?
      return message
    end

    # Downloads all chunks before playing them, stitching them together without the split second
    # of white nosie at the end of each mp3 (kinda hacky) to reduce the lag between the mp3's playing.
    def speech_download_first(message)
      chunks = []
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

      # Download each chunk, remove trailing white noise, save to same file.
      file_name = 'chunks_stitched.mp3'
      file = open(file_name, 'w:ASCII-8BIT')
      url = URI.parse('http://translate.google.com/')
      Net::HTTP.start(url.host, url.port) do |http|
        chunks.each_with_index do |chunk, index|
          http.request_get("/translate_tts?tl=en&q=#{URI::encode(chunk)}") do |resp|
            file.write(resp.body.gsub('UUUU', '')) #FIXME to less hacky solution. 
          end
        end
      end
      file.close

      # Play and delete the file
      `mpg123 -q #{file_name}`
      File.delete(file_name)
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