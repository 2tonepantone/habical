require 'google/apis/calendar_v3'
require 'google/api_client/client_secrets'

class GoogleCalendar
  CALENDAR_ID = 'primary'.freeze

  def initialize(current_user)
    @current_user = current_user
    @client = fetch_google_calendar_client
  end

  def call
    {
      client: fetch_google_calendar_client,
      busy_times: fetch_busy_times,
      calendar_events: fetch_calendar_events
    }
  end

  def add_event(task)
    event = Google::Apis::CalendarV3::Event.new(
      {
        summary: task[:title],
        start: {
          date_time: Time.new(task['start_date(1i)'], task['start_date(2i)'], task['start_date(3i)'], task['start_date(4i)'],
                              task['start_date(5i)']).to_datetime.rfc3339
        },
        end: {
          date_time: Time.new(task['end_date(1i)'], task['end_date(2i)'], task['end_date(3i)'], task['end_date(4i)'],
                              task['end_date(5i)']).to_datetime.rfc3339
        },
        reminders: {
          use_default: false,
          overrides: [
            Google::Apis::CalendarV3::EventReminder.new(
              reminder_method: 'popup', minutes: 10
            ),
            Google::Apis::CalendarV3::EventReminder.new(
              reminder_method: 'email', minutes: 20
            )
          ]
        },
        notification_settings: {
          notifications: [
            { type: 'event_creation', method: 'email' },
            { type: 'event_change', method: 'email' },
            { type: 'event_cancellation', method: 'email' },
            { type: 'event_response', method: 'email' }
          ]
        }, 'primary': true
      }
    )
    @client.insert_event('primary', event)
  end

  private

  def fetch_google_calendar_client
    client = Google::Apis::CalendarV3::CalendarService.new
    return unless @current_user.present? && @current_user.access_token.present? && @current_user.refresh_token.present?

    secrets = Google::APIClient::ClientSecrets.new({
                                                     'web' => {
                                                       'access_token' => @current_user.access_token,
                                                       'refresh_token' => @current_user.refresh_token,
                                                       'client_id' => ENV['GOOGLE_API_KEY'],
                                                       'client_secret' => ENV['GOOGLE_API_SECRET']
                                                     }
                                                   })
    begin
      client.authorization = secrets.to_authorization
      client.authorization.grant_type = 'refresh_token'

      unless @current_user.present?
        client.authorization.refresh!
        @current_user.update_attributes(
          access_token: client.authorization.access_token,
          refresh_token: client.authorization.refresh_token,
          expires_at: client.authorization.expires_at.to_i
        )
      end
    rescue StandardError => e
      flash[:error] = 'Your token has been expired. Please login again with google.'
      redirect_to :back
    end
    client
  end

  def fetch_busy_times
    client = fetch_google_calendar_client
    body = Google::Apis::CalendarV3::FreeBusyRequest.new
    body.items = ["id": 'primary']
    body.time_min = Time.now.iso8601
    body.time_max = (Time.now + 7 * 86_400).iso8601

    service = Google::Apis::CalendarV3::CalendarService.new
    service.authorization = client.authorization
    @response = service.query_freebusy(body)
    @busy_times = @response.calendars['primary'].busy
  end

  def fetch_calendar_events
    client = fetch_google_calendar_client
    @events = client.list_events(CALENDAR_ID,
                                 max_results: 10,
                                 single_events: true,
                                 order_by: 'startTime',
                                 time_min: Time.now.iso8601)
  end
end
