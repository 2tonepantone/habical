class TasksController < ApplicationController
  skip_before_action :authenticate_user!, only: :index
  before_action :fetch_gcal, only: :create
  before_action :fetch_schedule, only: :create

  def index
    return unless user_signed_in?

    begin
      fetch_gcal
      fetch_schedule
      @events = @schedule[:calendar_events]
      @busy_times = @schedule[:busy_times]
    rescue Google::Apis::AuthorizationError
      sign_out :user
      flash[:alert] = 'Your session has expired. Please login again.'
    end
  end

  def create
    @task = Task.new(task_params)
    @task.user_id = current_user.id
    return unless @task.save

    begin
      task = params[:task]
      task[:frequency].to_i.times { |repetition| @gcal.add_event(task, repetition) }
      flash[:notice] = 'Task was successfully added.'
      redirect_to root_path
    rescue Google::Apis::AuthorizationError
      sign_out :user
      redirect_to root_path
      flash[:alert] = 'Your session has expired. Please login again.'
    end
  end

  private

  def fetch_gcal
    @gcal = GoogleCalendar.new(current_user)
  end

  def fetch_schedule
    @schedule = @gcal.call
  end

  def task_params
    params.require(:task).permit(:title, :duration, :frequency, :timezone)
  end
end
