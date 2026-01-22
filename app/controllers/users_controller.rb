class UsersController < ApplicationController
  skip_before_action :require_login, only: [:new, :create]
  
  def new
    @user = User.new
  end
  
  def create
    @user = User.new(user_params)
    
    if @user.save
      session[:user_id] = @user.id
      redirect_to courses_path, notice: "Welcome to Home of Vessels, #{@user.name}! Your account has been created successfully."
    else
      flash.now[:alert] = @user.errors.full_messages.to_sentence
      render :new, status: :unprocessable_entity
    end
  end
  
  def profile
    @user = current_user
  end
  
  def update_profile
    @user = current_user
    
    if @user.update(user_params)
      redirect_to profile_path, notice: "Profile updated successfully!"
    else
      flash.now[:alert] = @user.errors.full_messages.to_sentence
      render :profile, status: :unprocessable_entity
    end
  end
  
  private
  
  def user_params
    params.require(:user).permit(:name, :email, :password, :password_confirmation)
  end
end