class TasksController < ApplicationController
  before_action :set_task, only: %i[show update destroy]

  def index
    tasks = Task.all
    tasks = tasks.filter_by_status(params[:status])
                 .filter_by_title(params[:title])
                 .filter_by_description(params[:description])
                 .filter_by_created_at(params[:created_at])
                 .filter_by_due_date(params[:due_date])
    render json: tasks
  end

  def show
    render json: @task
  end

  def create
    task = Task.new(task_params)
    task.status ||= 'em_andamento'

    if task.save
      render json: task, status: :created
    else
      render json: { errors: task.errors }, status: :unprocessable_entity
    end
  end

  def update
    if @task.update(task_params)
      render json: @task
    else
      render json: { errors: @task.errors }, status: :unprocessable_entity
    end
  end

  def destroy
    @task.update(status: 'cancelada')
    render json: @task
  end

  private

  def set_task
    @task = Task.find(params[:id])
  end

  def task_params
    params.require(:task).permit(:title, :description, :status, :due_date)
  end
end
