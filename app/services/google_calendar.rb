require 'google/apis/calendar_v3'
require 'google/api_client/client_secrets'

class GoogleCalendar
  CALENDAR_ID = 'primary'.freeze

  def initialize(current_user)
    @current_user = current_user
    @client = fetch_google_calendar_client
  end

  def call
    { busy_times: fetch_busy_times, calendar_events: fetch_calendar_events }
  end

  def add_event(task)
    free_slot = get_free_time_slot(task[:duration].to_i)
    event = Google::Apis::CalendarV3::Event.new(
      {
        summary: task[:title],
        start: {
          date_time: free_slot[:start].rfc3339
        },
        end: {
          date_time: free_slot[:end].rfc3339
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
    body = Google::Apis::CalendarV3::FreeBusyRequest.new
    body.items = ["id": 'primary']
    body.time_min = Time.now.iso8601
    body.time_max = (Time.now + 7 * 86_400).iso8601

    service = Google::Apis::CalendarV3::CalendarService.new
    service.authorization = @client.authorization
    response = service.query_freebusy(body)
    response.calendars['primary'].busy
  end

  def get_free_time_slot(task_duration, buffer = 10, day_start = 9, day_end = 21)
    busy_times = fetch_busy_times
    # If no busy times, add task one hour from now
    return { start: (Time.now + 3600), end: (Time.now + 3600 + (task_duration * 60)) } if busy_times.empty?

    busy_times.each_with_index do |busy_time, index|
      slot_start = get_slot_start(busy_time, buffer, task_duration, index)
      next_index = busy_times[index.next] ? index.next : index
      # If last event use that event's end (slot_start) to schedule the next event
      slot_end = if next_index == index
                   slot_start.advance(minutes: task_duration)
                 else
                   get_slot_end(busy_times[next_index], buffer, task_duration)
                 end
      # Check that the task can fit in the alloted time slot and that it would be scheduled within the set active period
      if slot_start <= slot_end && slot_start.localtime.hour >= day_start && slot_start.advance(minutes: task_duration).localtime.hour < day_end
        return { start: slot_start,
                 end: slot_start.advance(minutes: task_duration) }
      end
    end
  end

  def get_slot_start(busy_time, buffer, task_duration, index)
    if DateTime.current.advance(minutes: 60 + task_duration) < busy_time.start && index.zero?
      DateTime.current.advance(minutes: 60)
    else
      busy_time.end.advance(minutes: buffer)
    end
  end

  def get_slot_end(busy_time, buffer, task_duration)
    busy_time.start.advance(minutes: -buffer - task_duration)
  end

  def fetch_calendar_events
    @events = @client.list_events(CALENDAR_ID,
                                  max_results: 10,
                                  single_events: true,
                                  order_by: 'startTime',
                                  time_min: Time.now.iso8601)
  end
end
