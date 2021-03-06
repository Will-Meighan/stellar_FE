class SessionsController < ApplicationController
  def create
    user = User.find_by(email: google_auth_hash["info"]["email"])
    if !user.nil?
      session[:user_id] = user.id
      redirect_to '/profile'
    else
      user = User.create!(
                        first_name: user_info["first_name"],
                        last_name: user_info["last_name"],
                        email: user_info["email"],
                        google_token: google_token)
      session[:user_id] = user.id
      redirect_to '/profile'
    end
  end

  def destroy
    session.delete(:user_id)
    redirect_to '/', :flash => { :notice => "You have been logged out." }
  end

  private

  def google_auth_hash
    request.env["omniauth.auth"]
  end

  def google_token
    google_auth_hash["credentials"]
  end

  def user_info
    google_auth_hash["info"]
  end
end
