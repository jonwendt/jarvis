class Alarm < ActiveRecord::Base
  include Speech
  # Save alarms in the correct local time but with the UTC timezone, so it is not changed when saved. Schedules using the current date
  # in time zone, plus the hours and minutes of the alarm time, so it will be correct when scheduled.

  def play_message
    message = self.message + ". The time is now #{Time.now.in_time_zone.strftime('-%l:%M %P')}"
    say(message)
    return message
  end

  def self.schedule_alarms
    alarms = Alarm.where("days = 'ALL'") # Implement days as string
    alarms.each do |alarm|
      time = Date.today.in_time_zone + alarm.time.hour.hours + alarm.time.min.minutes
      AlarmBellJob.perform_at(time, alarm.id)
    end
  end
end
