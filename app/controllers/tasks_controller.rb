class TasksController < ApplicationController
  before_action :require_user_logged_in
  before_action :correct_user, only: [:destroy]
  before_action :set_task, only: [:show, :edit, :update, :destroy]
  def index
    
      # @tasks = current_user.tasks.all.order(created_at: :desc).page(params[:page]).per(5)
      @tasks = current_user.tasks.order(created_at: :desc).page(params[:page]).per(5)
  end
  
  def show
     
    set_task
  end
  
  def new
   
    @task = Task.new
  end
  
  def create
   
    @task = current_user.tasks.new(task_params)
    if @task.save
      flash[:success] = 'Task　が正常に投稿されました'
      redirect_to @task
    else
      @tasks = current_user.tasks.order('created_at DESC').page(params[:page])
      flash.now[:danger] = 'Task が投稿されませんでした'
      render :new
    end
  end
  
  def edit
    # binding.pry
    set_task
  end
  
  def update
    set_task
    
    if @task.update(task_params)
      flash[:success] = 'Task は正常に更新されました'
      redirect_to @task
    else
      flash.now[:danger] = 'Task は更新されませんでした'
      render :edit
    end
  end
  
  def destroy
    set_task
    @task.destroy
    
    flash[:success] = 'Task は正常に削除されました'
    redirect_to tasks_url
    
  end
  
  private
  
  def set_task
    @task = Task.find(params[:id])
  end
  
  def task_params
    params.require(:task).permit(:content, :status,:user_id)
  end
  
  def correct_user
    @task = current_user.tasks.find_by(id: params[:id])
    unless @task
      redirect_to root_url
    end
  end
  
end
