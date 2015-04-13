class AlarmBellJob
  include Sidekiq::Worker
  include Speech
  sidekiq_options :retry => false, :backtrace => true

  def perform(id)
    return if cancelled?
    songs = Dir[Rails.root.join('lib', 'assets', 'music', '*')].shuffle[0..2]
    alarm = Alarm.find(id)
    alarm.play_message
    return if cancelled?
    songs.first.present? ? play_song(songs.shift) : (sleep 60)
    return if cancelled?
    alarm.play_message
    return if cancelled?
    songs.first.present? ? play_song(songs.shift) : (sleep 60 * 4)
    return if cancelled?
    alarm.play_message
    return if cancelled?
    play_song(songs.shift)
  end

  def cancelled?
    Sidekiq.redis { |c| c.exists "cancelled-#{jid}" }
  end

  def self.cancel!(alarm_id)
    worker = Sidekiq::Workers.new.to_a.select { |worker| worker.third['payload']['args'].first == alarm_id }.first
    jid = worker.third['payload']['jid']
    Sidekiq.redis {|c| c.setex("cancelled-#{jid}", 86400, 1) }
  end
end
