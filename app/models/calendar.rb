require 'google/api_client'
require 'google/api_client/client_secrets'
require 'google/api_client/auth/installed_app'
require 'google/api_client/auth/storage'
require 'google/api_client/auth/storages/file_store'
require 'fileutils'

class Calendar
  include Sidekiq::Worker
  include Speech

  APPLICATION_NAME = 'Jarvis Calendar API'
  CLIENT_SECRETS_PATH = 'config/calendar/client_secret.json'
  CREDENTIALS_PATH = File.join(Rails.root, 'config', 'calendar', '.credentials',
                               "calendar-api-quickstart.json")
  SCOPE = 'https://www.googleapis.com/auth/calendar.readonly'

  ##
  # Ensure valid credentials, either by restoring from the saved credentials
  # files or intitiating an OAuth2 authorization request via InstalledAppFlow.
  # If authorization is required, the user's default browser will be launched
  # to approve the request.
  #
  # @return [Signet::OAuth2::Client] OAuth2 credentials
  def self.authorize
    FileUtils.mkdir_p(File.dirname(CREDENTIALS_PATH))

    file_store = Google::APIClient::FileStore.new(CREDENTIALS_PATH)
    storage = Google::APIClient::Storage.new(file_store)
    auth = storage.authorize

    if auth.nil? || (auth.expired? && auth.refresh_token.nil?)
      app_info = Google::APIClient::ClientSecrets.load(CLIENT_SECRETS_PATH)
      flow = Google::APIClient::InstalledAppFlow.new({
        :client_id => app_info.client_id,
        :client_secret => app_info.client_secret,
        :scope => SCOPE})
      auth = flow.authorize(storage)
      puts "Credentials saved to #{CREDENTIALS_PATH}" unless auth.nil?
    end
    auth
  end

  # Test if the user is authorized. TODO - restrict to User
  def perform
    # Initialize the API
    client = Google::APIClient.new(:application_name => APPLICATION_NAME)
    calendar_api = client.discovered_api('calendar', 'v3')
    client.authorization = self.class.authorize

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
    puts "No upcoming events found" if results.data.items.empty?
    results.data.items.each do |event|
      start = event.start.date || event.start.date_time
      puts "- #{event.summary} (#{start})"
    end
  end

  def self.read_events
    # Initialize the API
    client = Google::APIClient.new(:application_name => APPLICATION_NAME)
    calendar_api = client.discovered_api('calendar', 'v3')
    client.authorization = authorize

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