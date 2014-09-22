class UserMailer < ActionMailer::Base
  default from: "mpjeno@gmail.com"
  
  # Sends an email when a new user is created
  def welcome(user)
    @user = user
    
    mail(:to => user.email, :subject => "Registered")
  end
  
  #Sends an email when a user is assigned a task
  def task_assigned(user, task)
    @user = user
    @task = task
    
    mail(:to => user.email, :subject => "A task has been assigned to you")    
  end
  
  # Sends an email when an assigned task is marked complete
  def task_completed(user, task)
    @user = user
    @task = task
    
    mail(:to => user.email, :subject => "Your task has been completed")
  end
  
end