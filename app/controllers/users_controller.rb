class UsersController < ApplicationController
  skip_before_filter :authorize, :only => [:new, :create, :edit]
  @@update_notice = "User info updated! Way to go."
  @@delete_notice = "User has been deleted"
  
  def new
    @user = User.new
  end

  def create
    @user = User.new(params[:user])

    if @user.save
      UserMailer.welcome(@user).deliver
      redirect_to dashboard_path(@user.id)
    else
      render "new"
    end
  end

  def show
    @user = User.find(params[:id])
  end

  def index
    @users = User.all
  end

  def edit
    @user = User.find(params[:id])
  end

  def update
    @user = User.find(params[:id])

    if @user.update_attributes(params[:user])
      redirect_to user_path(@user.id), :notice => @@update_notice
    else
      render "edit"
    end
  end

  def destroy
    @user = User.find(params[:id])
    @user.destroy
    Activity.delete_tracked_users(@user.id)
    reset_session

    redirect_to root_path, :notice => @@delete_notice
  end
end
