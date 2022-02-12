class TasksController < ApplicationController
  before_action :fetch_gcal, only: %i[index create]
  before_action :fetch_schedule, only: %i[index create]

  def index
    @events = @schedule[:calendar_events]
    @busy_times = @schedule[:busy_times]
    @tasks = Task.all
  end

  def create
    @task = Task.new(task_params)
    @task.user_id = current_user.id
    if @task.save
      task = params[:task]
      task[:frequency].to_i.times { @gcal.add_event(task) }
      flash[:notice] = 'Task was successfully added.'
      redirect_to root_path
    else
      redirect_to root_path(@task), alert:
        "Cannot add task. #{@task.errors.full_messages.join(', ')}."
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
    params.require(:task).permit(:title, :duration, :frequency)
  end
end
