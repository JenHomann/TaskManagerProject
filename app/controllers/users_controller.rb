class UsersController < ApplicationController
  skip_before_filter :authorize
  
  def new
    @user = User.new
  end
  
  def create
    @user = User.new(params[:user])
    
    if @user.save
      redirect_to user_path(@user.id), :notice => "The user has been created."
    else
      raise "User could not be saved."
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
      redirect_to user_path(@user.id), :notice => "User info updated! Way to go."
    else
      render "edit"
    end
  end
  
  def destroy
     @user = User.find(params[:id])
     @user.destroy

     redirect_to users_path, :notice => "The user has been deleted."
   end
end
