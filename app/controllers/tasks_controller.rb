require 'pony'

class TasksController < ApplicationController
  skip_before_filter :authorize, :only => [:index, :show]
  
  @@task_new = "You have a new saved task! Click the edit link to assign it to a user."
  @@task_alert = "Oops! Something went wrong! Please try again."
  @@add_category = "The category has been successfully added to this task."
  @@comment = "New comment saved! Way to go."
  @@comment_a = "You must be logged in to do leave a comment."
  @@task_u = "Task updated! Way to go."
  @@task_d = "Your task has been deleted."
  
  def index
    @tasks = Task.all
    @tasks.sort! { |a, b| a.order <=> b.order }
  end

  def new
    @task = Task.new
  end

  def create
    @task = Task.new(params[:task])

    if @task.save
      track_activity @task

      redirect_to dashboard_path(@task.id), :notice => @@task_new
    else
      flash[:alert] = @@task_alert
      render "new"
    end
  end

  def edit
    @task = Task.find(params[:id])

    @projects = Project.all

    @categories = Category.all
    @users = User.all
  end

  def add_category
    @task = Task.find(params[:id])

    @category = Category.find(params[:task][:categories].to_i)

    if @task.categories.include? @category
      render "show"
    else
      @task.categories << @category

      redirect_to task_path(@task.id), :notice => @@add_category
    end
  end

  def add_user
    @task = Task.find(params[:id])
    @user = User.find(params[:task][:users].to_i)

    if @task.users.include? @user
      render "show"
    else
      @task.users << @user

      Pony.mail(:to => @user.email, :from => 'rpjktest.email@gmail.com', :subject => 'hi ' + @user.name, :body => 'Hello there ' + @user.name + ' your task is ' + @task.name, :via => :smtp, :via_options => { :address => 'smtp.gmail.com',
      :port => '587', :authentication => :plain, :user_name => 'rpjktest.email@gmail.com', :password => 'Testpassword' })

      redirect_to task_path(@task.id), :notice => "The task has been assigned to #{@user.name}."
    end
  end

  def add_comment
    @user = current_user
    @task = Task.find(params[:id])
    @comment = Comment.new(comment_text: params[:comment][:comment_text], user_id: current_user.id, task_id: @task.id)

    if @comment.save

      redirect_to task_path(@task.id), :notice => @@comment
    else
      render "login", :alert => @@comment_a
    end
  end

  def update
    @task = Task.find(params[:id])
    
    if @task.update_attributes(params[:task])
      track_activity @task

      redirect_to task_path(@task.id), :notice => @@task_u
    else
      render "edit"
    end
  end

  def destroy
    @task = Task.find(params[:id])
    delete_tracked_tasks
    @task.delete

    redirect_to dashboard_path, :notice => @@task_d
  end

  def show
    @task = Task.find(params[:id])
    @user = current_user
    @comment = Comment.new
  end
end
