class AccessController < ApplicationController
  layout 'admin'

  before_action :confirm_logged_in, :except => [:login, :attempt_login, :logout]

  def menu
    @username = session[:username]
  end

  def login
  end

  def attempt_login
    if params[:username].present? && params[:password].present?
      found_user = AdminUser.where(:username => params[:username]).first
      if found_user
        authorized_user = found_user.authenticate(params[:password])
      end
    end

    if authorized_user
      session[:user_id] = authorized_user.id
      session[:username] = authorized_user.username # stores the user at login to not have to find again
      flash[:notice] = "You are now logged in."
      redirect_to(admin_path)
    else
      # flash.now displays the message in the current page, instead of in the following page
      flash.now[:notice] = 'Invalid username/password combination.'
      render('login')
    end
  end

  def logout
    session[:user_id] = nil
    session[:username] = nil
    flash[:notice] = 'Logged Out'
    redirect_to(access_login_path)
  end

end
