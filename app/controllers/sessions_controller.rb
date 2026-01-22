class SessionsController < ApplicationController
  skip_before_action :require_login, only: [:new, :create, :forgot_password, :send_reset_instructions, :reset_password, :update_password, :destroy]
  
  def new
    redirect_to courses_path if logged_in?
  end
  
  def create
    user = User.find_by(email: params[:email]&.downcase)
    
    if user && user.authenticate(params[:password])
      session[:user_id] = user.id
      redirect_to session.delete(:return_to) || courses_path, notice: "Welcome back, #{user.name}!"
    else
      flash.now[:alert] = "Invalid email or password"
      render :new, status: :unprocessable_entity
    end
  end
  
  def destroy
    session[:user_id] = nil
    session[:return_to] = nil
    redirect_to root_path, notice: "Successfully logged out!"
  end
  
  def forgot_password
  end
  
  def send_reset_instructions
    user = User.find_by(email: params[:email].downcase)
    
    if user
      user.generate_password_reset_token
      # In a real app, you would send an email here
      # For demo purposes, we'll show the reset link
      reset_url = reset_password_url(token: user.reset_password_token)
      flash[:info] = "Password reset instructions have been sent to your email. Demo: <a href='#{reset_url}' class='underline'>Click here to reset password</a>"
      redirect_to login_path
    else
      flash.now[:alert] = "No account found with that email address"
      render :forgot_password, status: :unprocessable_entity
    end
  end
  
  def reset_password
    @user = User.find_by(reset_password_token: params[:token])
    
    unless @user && @user.password_reset_token_valid?
      redirect_to forgot_password_path, alert: "Invalid or expired password reset link"
    end
  end
  
  def update_password
    @user = User.find_by(reset_password_token: params[:token])
    
    if @user && @user.password_reset_token_valid?
      if @user.update(password: params[:password], password_confirmation: params[:password_confirmation])
        @user.clear_password_reset_token
        redirect_to login_path, notice: "Password has been reset successfully. Please log in with your new password."
      else
        flash.now[:alert] = @user.errors.full_messages.to_sentence
        render :reset_password, status: :unprocessable_entity
      end
    else
      redirect_to forgot_password_path, alert: "Invalid or expired password reset link"
    end
  end
end