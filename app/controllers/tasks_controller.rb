class TasksController < ApplicationController
  before_action :fetch_gcal, only: %i[index create]
  before_action :fetch_schedule, only: %i[index create]

  def index
    @events = @schedule[:calendar_events]
    @busy_times = @schedule[:busy_times]
  end

  def new
    @task = Task.new
  end

  def create
    @task = Task.new(task_params)
    @task.user_id = current_user.id
    @task.save!
    task = params[:task]
    @gcal.add_event(task)
    flash[:notice] = 'Task was successfully added.'
    redirect_to tasks_path
  end

  private

  def fetch_gcal
    @gcal = GoogleCalendar.new(current_user)
  end

  def fetch_schedule
    @schedule = @gcal.call
  end

  def task_params
    params.require(:task).permit(:title, :duration)
  end
end
