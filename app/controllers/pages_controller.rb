class PagesController < ApplicationController
  skip_before_action :require_login, only: [:home, :about, :gallery, :contact, :newsletter_subscribe, :contact_form]
  def home
  end

  def about
  end

  def courses
  @logged_in = session[:user_id].present?
  end

  def gallery
  end

  def contact
  end

  def newsletter_subscribe
    # Handle newsletter subscription
    flash[:notice] = "Thank you for subscribing to our newsletter!"
    redirect_back fallback_location: root_path
  end

  def contact_form
    # Handle contact form submission
    flash[:notice] = "Thank you for your message! We will get back to you soon."
    redirect_to contact_path
  end

  def enroll
    # Handle course enrollment
    if params[:logged_in] == "true"
      flash[:notice] = "Successfully enrolled in the course!"
    else
      flash[:alert] = "Please log in to enroll in courses."
    end
    redirect_to courses_path
  end
end