require 'google/apis/calendar_v3'
require 'google/api_client/client_secrets'

class GoogleCalendar
  CALENDAR_ID = 'primary'.freeze

  def initialize(current_user)
    @current_user = current_user
    @client = fetch_google_calendar_client
    @skipped_days = 0
  end

  def call
    { busy_times: fetch_busy_times, calendar_events: fetch_calendar_events }
  end

  def add_event(task, repetition)
    free_slot = get_free_time_slot(task[:duration].to_i, repetition, task[:timezone])
    event = get_event(task, free_slot)
    @client.insert_event('primary', event)
  end

  private

  def get_event(task, free_slot)
    Google::Apis::CalendarV3::Event.new(
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
  end

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

  def fetch_busy_times(time_min = Time.now.iso8601, time_max = Time.now.advance(days: 7).iso8601)
    body = Google::Apis::CalendarV3::FreeBusyRequest.new
    body.items = ["id": 'primary']
    body.time_min = time_min
    body.time_max = time_max

    service = Google::Apis::CalendarV3::CalendarService.new
    service.authorization = @client.authorization
    response = service.query_freebusy(body)
    response.calendars['primary'].busy
  end

  def get_free_time_slot(task_duration, repetition, timezone, buffer = 10, day_start = 9, day_end = 21)
    Time.zone = (timezone)
    day_start = Time.current.change(hour: day_start).advance(days: repetition + @skipped_days).utc
    day_end = Time.current.change(hour: day_end).advance(days: repetition + @skipped_days).utc
    searching = true
    while searching
      busy_times = day_start.today? ? fetch_busy_times(Time.now.iso8601, Time.now.change(hour: 24).iso8601) : fetch_busy_times(day_start.iso8601, day_end.iso8601)
      if busy_times.empty?
        time_slot = handle_empty_schedule(day_start, task_duration)
        next unless valid_time_slot?(time_slot[:start], time_slot[:end], day_start, day_end, task_duration)

        searching = false
        return time_slot
      end

      busy_times.each_with_index do |busy_time, index|
        slot_start = get_slot_start(busy_times, busy_time, buffer, task_duration)
        slot_end = get_slot_end(busy_times, buffer, task_duration, slot_start, index)
        # Check that the task can fit in the alloted time slot and that it would be scheduled within the set active period
        next unless valid_time_slot?(slot_start, slot_end, day_start, day_end, task_duration)

        searching = false
        return { start: slot_start,
                 end: slot_start.advance(minutes: task_duration) }
      end
      day_start = day_start.advance(days: 1)
      day_end = day_end.advance(days: 1)
      @skipped_days += 1
    end
  end

  def valid_time_slot?(slot_start, slot_end, day_start, day_end, task_duration)
    Time.now < slot_start && slot_start <= slot_end && slot_start >= day_start &&
      slot_start.advance(minutes: task_duration) <= day_end
  end

  def get_slot_start(busy_times, busy_time, buffer, task_duration)
    is_first_busy_slot = busy_time == busy_times.first
    start_time = busy_time.start.today? ? DateTime.current.advance(hours: 1) : busy_time.start.change(hour: 10)
    # Can't I theoretically get both start and end time here using start_time.advance(minutes: task_duration)?
    if is_first_busy_slot && start_time.advance(minutes: task_duration) < busy_time.start
      start_time
    else
      busy_time.end.advance(minutes: buffer)
    end
  end

  def get_slot_end(busy_times, buffer, task_duration, slot_start, index)
    # If last/only event use that event's end (slot_start) to schedule the next event
    next_index = busy_times[index.next] ? index.next : index
    return slot_start.advance(minutes: task_duration) if next_index == index

    busy_times[next_index].start.advance(minutes: -buffer - task_duration)
  end

  def handle_empty_schedule(day_start, task_duration)
    # If no busy times, add task one hour from now or the day start
    if day_start.today?
      { start: Time.now.advance(hours: 1),
        end: Time.now.advance(minutes: 60 + task_duration) }
    else
      { start: day_start.advance(hours: 1),
        end: day_start.advance(minutes: 60 + task_duration) }
    end
  end

  def fetch_calendar_events
    @events = @client.list_events(CALENDAR_ID,
                                  single_events: true,
                                  order_by: 'startTime',
                                  time_min: Time.parse(Date.today.beginning_of_month.to_s).iso8601,
                                  time_max: Time.parse(Date.today.next_month.end_of_month.to_s).iso8601)
  end
end
