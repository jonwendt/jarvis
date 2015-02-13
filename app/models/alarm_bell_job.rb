class AlarmBellJob
  include Sidekiq::Worker
  sidekiq_options :retry => false, :backtrace => true

  def perform(id)
    songs = Dir[Rails.root.join('lib', 'assets', 'music', '*')].shuffle[0..2]
    alarm = Alarm.find(id)
    alarm.play_message
    songs.first.present? ? `mpg123 "#{songs.shift}"` : (sleep 60)
    alarm.play_message
    songs.first.present? ? `mpg123 "#{songs.shift}"` : (sleep 60 * 4)
    alarm.play_message
    `mpg123 "#{songs.shift}"`
  end

end