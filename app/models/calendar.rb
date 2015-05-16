require 'google/api_client'

class Calendar
  include Sidekiq::Worker
  include Speech

  APPLICATION_NAME = 'Jarvis Calendar API'

  # Test if the user is authorized. TODO - restrict to User
  def perform(user_id)
    # Initialize the API
    client = Google::APIClient.new(:application_name => APPLICATION_NAME)
    calendar_api = client.discovered_api('calendar', 'v3')
    client.authorization.access_token = User.find(user_id).token.fresh_token

    # Fetch the next 10 events for the user
    results = client.execute!(
      :api_method => calendar_api.events.list,
      :parameters => {
        :calendarId => 'primary',
        :maxResults => 10,
        :singleEvents => true,
        :orderBy => 'startTime',
        :timeMin => Time.now.iso8601,
        :timeMax => (Time.now + 2.days).iso8601 })

    puts "Upcoming events:"
    if results.data.items.empty?
      puts "No upcoming events found" 
    else
      say "Upcoming events."
      results.data.items.each do |event|
        start = event.start.date || event.start.date_time
        if start.day == Time.now.day
          date = 'today'
        elsif start.day == Time.now.day + 1
          date = 'tomorrow'
        else
          date = "on the #{start.day.ordinalize}"
        end
        say "#{event.summary} starts at #{start.strftime('%-l:%M %P')} #{date}"
      end
    end
  end
end