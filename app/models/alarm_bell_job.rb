class AlarmBellJob
  include Sidekiq::Worker

  def perform(id)
    alarm = Alarm.find(id)
    alarm.play_message
    sleep 60
    alarm.play_message
    sleep 60 * 4
    alarm.play_message
  end
end