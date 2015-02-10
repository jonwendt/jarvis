class Alarm < ActiveRecord::Base
  def play_message
    message = self.message + ". The time is now #{Time.now.strftime('%l:%M %P')}"
    `sudo #{Rails.root.join('bin')}/speech.sh "#{message}"`
    return message
  end
end
