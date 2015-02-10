class Alarm < ActiveRecord::Base
  include Speech

  def play_message
    message = self.message + ". The time is now #{Time.now.in_time_zone.strftime('%l:%M %P')}"
    say(message)
    return message
  end

  def self.schedule_alarms
    alarms = Alarm.where("days = 'ALL'") # Implement days as string
    alarms.each do |alarm|
      time = Time.now.in_time_zone.to_date + alarm.time.hour.hours + alarm.time.min.minutes
      AlarmBellJob.perform_at(time, alarm.id)
    end
  end
end
