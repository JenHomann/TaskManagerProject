class ApplicationController < ActionController::Base
  before_filter :authorize
  protect_from_forgery

  def current_user
    if session[:user_id]
      if @user = User.find_by_id(session[:user_id])
        @user
      else 
        reset_session
        redirect_to root_path
      end  
    end 
  end

  def authorize
    if current_user.nil?
      redirect_to root_path
    end
  end

  def track_activity(trackable, action = params[:action])
    current_user.activities.create! action: action, trackable: trackable
  end

  # def delete_tracked_projects
  #   Activity.where(trackable_type: "Project", trackable_id: @project_id).each do |a|
  #     a.delete
  #   end
  # end
  #
  # def delete_tracked_tasks
  #   Activity.where(trackable_type: "Task", trackable_id: @task.id).each do |a|
  #     a.delete
  #   end
  # end
  #
  # def delete_tracked_users
  #   Activity.where(:user_id => @user.id).each do |a|
  #     a.delete
  #   end
  # end

  def delete_slug(model)
    model.find_by_slug(params[:id]).delete
  end

  helper_method :current_user
end
